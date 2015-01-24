class Event
  attr_reader :payload, :sender, :repository

  def initialize(github_event_name, payload)
    @github_event_name = github_event_name
    @payload = payload
    @repository = Repository.from_github(payload[:repository])
    @sender = GithubUser.from_github(payload[:sender])
  end

  def name
    case @github_event_name
    when "pull_request"
      case @payload[:action]
      when "opened"; :pull_request_opened
      when "closed"; :pull_request_closed
      end
    when "issue_comment"
      case @payload[:action]
      when "created"; :pull_request_comment
      end
    end
  end

  def pull_request_hash
    case @github_event_name
    when "pull_request"; @payload[:pull_request]
    when "issue_comment"; @payload[:issue][:pull_request]
    end
  end

  def pull_request_url
    pull_request_hash[:html_url]
  end

  def comment_hash
    raise ArgumentError unless @github_event_name == "issue_comment"

    @payload[:comment]
  end

  private

  def action
    @payload[:action]
  end
end
