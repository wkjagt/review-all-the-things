class GithubEventsController < ApplicationController

  def webhook
    case @event_name
    when :pull_request_opened; process_pull_request_opened
    when :pull_request_comment; process_pull_request_comment
    end

    head :ok
  end

  private

  def process_pull_request_opened
    @pull_request.parsed_body.mentions.each do |reviewer|
      @pull_request.reviewers.create(github_user: reviewer)
    end
  end

  def process_pull_request_comment
    return unless reviewer = @sender.reviews?(@pull_request)

    reviewer.reject if @comment.rejected?
    reviewer.approve if @comment.approved?
  end
end
