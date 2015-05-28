class UsersController < ApplicationController

  before_action :set_headers
  respond_to :json, :html

  def show
    @user = current_user

    return head :not_found unless @user
    return redirect_to '/auth/github' unless current_user
  end

  def user_log
    return head :forbidden unless current_user
    render json: current_user.feed
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
