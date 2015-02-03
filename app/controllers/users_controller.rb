class UsersController < ApplicationController

  before_action :set_headers, :validate_secret
  respond_to :json, :html

  def show
    @user = GithubUser.find_by(github_username: params[:user])
    respond_with @user.prs_to_review
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def validate_secret
    head :forbidden unless params["application-secret"] == secret_for_username(params["user"])
  end

  def secret_for_username(username)
    Digest::MD5.hexdigest("replace_with_secret-#{username}")
  end
end
