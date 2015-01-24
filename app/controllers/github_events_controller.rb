class GithubEventsController < ApplicationController

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

    return unless review = comment.sender.reviews?(pull_request)

    review.reject if comment.rejected?
    review.approve if comment.approved?
  end

  def process_pull_request_closed
    pull_request = PullRequest.find_by(url: event.pull_request_url)
    return unless pull_request.present?
    pull_request.close
  end
end
