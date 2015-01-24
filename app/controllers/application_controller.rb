class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  attr_reader :event

  before_action #, :verify_signature

  private

  def event
    return @event if @event

    @event = Event.new(
      request.headers["X-Github-Event"],
      JSON.parse(request.body.read, symbolize_names: true))
  end

  def verify_signature
    secret_token = "mysecret"
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret_token, request.body.read)
    head :unauthorized unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
