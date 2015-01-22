class GithubEventsController < ApplicationController

  def webhook
    case @event
    when :pull_request_opened; process_pull_request_opened
    when :pull_request_closed; process_pull_request_closed
    when :pull_request_comment; process_pull_request_comment
    end

    head :ok
  end

  private

  def process_pull_request_opened
    @pull_request = @sender.open_pull_request(@payload["pull_request"], @repository)
    puts @pull_request
    @pull_request.parsed_body.mentions.each do |reviewer|
      @pull_request.reviewers.create(github_user: reviewer)
    end
  end

  def process_pull_request_comment
    @pull_request = PullRequest.find_by!(url: @payload["issue"]["pull_request"]["html_url"])
    @comment = Comment.new(@payload["comment"])

    return unless reviewer = @sender.reviews?(@pull_request)

    reviewer.reject if @comment.rejected?
    reviewer.approve if @comment.approved?
  end

  def process_pull_request_closed
    @pull_request = PullRequest.find_by(url: @payload["pull_request"]["html_url"])
    return unless @pull_request.present?
    @pull_request.close
  end
end
