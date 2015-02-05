class UsersController < ApplicationController

  before_action :set_headers
  respond_to :json, :html

  def show
    @user = GithubUser.find_by(github_username: params[:user])

    return head :not_found unless @user
    return head :forbidden unless params["application-secret"] == @user.secret

    render json: @user.prs_to_review.to_json(include: :github_user)
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
