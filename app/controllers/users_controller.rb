class UsersController < ApplicationController

  before_action :set_headers
  respond_to :json, :html

  def show
    @user = current_user

    return head :not_found unless @user
    return redirect_to '/auth/github' unless current_user
  end

  def user_log
    return head :forbidden unless params["application-secret"] == current_user.secret
    render json: current_user.prs_to_review.to_json(include: :github_user)
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
