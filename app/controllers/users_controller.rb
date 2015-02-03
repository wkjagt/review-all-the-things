class UsersController < ApplicationController

  before_action :set_headers
  respond_to :json

  def show
    @user = GithubUser.find_by(github_username: params[:user])
    respond_with @user.prs_to_review
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['willem'] = 'sdcsd'
  end
end
