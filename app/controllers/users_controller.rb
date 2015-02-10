class UsersController < ApplicationController

  before_action :set_headers
  respond_to :json, :html

  def show
    @user = GithubUser.find_by(github_username: params[:user])

    return head :not_found unless @user

    respond_to do |format|
      format.json do
        return head :forbidden unless params["application-secret"] == @user.secret
        render json: @user.prs_to_review.to_json(include: :github_user)
      end

      format.html do
        return redirect_to '/auth/github' unless current_user
      end
    end

  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
