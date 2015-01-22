class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :set_event_info#, :verify_signature

  private

  def set_event_info
    puts request.headers["X-Github-Event"]
    puts JSON.parse(request.body.read)
    return


    @payload = JSON.parse(request.body.read)
    @repository = Repository.from_github(@payload["repository"])
    @sender = GithubUser.from_github(@payload["sender"])
    @event = event_name
  end

  def event_name
    case request.headers["X-Github-Event"]
    when "pull_request"
      case @payload["action"]
      when "opened";  :pull_request_opened
      when "closed";  :pull_request_closed
      end
    when "issue_comment"
      case @payload["action"]
      when "created"; :pull_request_comment
      end
    end
  end

  def verify_signature
    secret_token = "mysecret"
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, request.body.read)
    head :unauthorized unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
