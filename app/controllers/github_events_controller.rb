class GithubEventsController < ApplicationController
  before_action :verify_signature
  protect_from_forgery with: :null_session
  respond_to :json

  def webhook
    case event.name
    when :pull_request_opened; process_pull_request_opened
    when :pull_request_closed; process_pull_request_closed
    when :pull_request_comment; process_pull_request_comment
    end

    head :ok
  end

  private

  def process_pull_request_opened
    pull_request = event.sender.open_pull_request(event.pull_request_hash, event.repository)

    pull_request.parsed_body.mentions.each do |username|
      pull_request.reviews.create(github_user: username)
    end
  end

  def process_pull_request_comment
    pull_request = PullRequest.find_by!(url: event.pull_request_url)
    comment = Comment.new(event.comment_hash)
    owner = pull_request.github_user

    if comment.commenter == owner
      comment.parsed_body.mentions.each do |github_user|
        pull_request.reviews.find_or_create_by(github_user: github_user).update_attribute(:status, :to_review)
      end
    elsif comment.commenter.reviews?(pull_request)
      review = comment.commenter.reviews.find_by(pull_request: pull_request)
      review.reject if comment.rejected?
      review.approve if comment.approved?
    end
  end

  def process_pull_request_closed
    pull_request = PullRequest.find_by(url: event.pull_request_url)
    return unless pull_request.present?
    pull_request.close
  end

  def event
    return @event if @event

    @event = Event.new(
      request.headers["X-Github-Event"],
      JSON.parse(request.body.read, symbolize_names: true))
  end

  def verify_signature
    return unless Rails.configuration.github_webhooks_validate_secret
    secret = Rails.configuration.github_webhooks_secret
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request.body.read)
    head :unauthorized unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
