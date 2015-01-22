class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :set_event_info#, :verify_signature

  private

  def set_event_info
    # I don't use params, because GitHub uses am "action" param
    # that rails overwrites
    @payload = JSON.parse(request.body.read)
    @repository = Repository.from_github(@payload["repository"])
    @sender = GithubUser.from_github(@payload["sender"])

    prepare_event

    # don't continue without pull request
    head :ok unless @pull_request
  end

  def prepare_event
    case request.headers["X-Github-Event"]
    when "pull_request"; prepare_pull_request
    when "issue_comment"; prepare_issue_comment
    end
  end

  def prepare_pull_request
    case @payload["action"]
    when "opened"
      @pull_request = @sender.open_pull_request(@payload["pull_request"], @repository)
      @event = :pull_request_opened
    when "closed"
      @pull_request = PullRequest.find_by(url: @payload["pull_request"]["html_url"])
      @event = :pull_request_closed
    end
  end

  def prepare_issue_comment
    @pull_request = PullRequest.find_by!(url: @payload["issue"]["pull_request"]["html_url"])
    @comment = Comment.new(@payload["comment"])
    @event = :pull_request_comment
  end

  def verify_signature
    secret_token = "mysecret"
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, request.body.read)
    head :unauthorized unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
