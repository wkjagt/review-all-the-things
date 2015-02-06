class ApplicationController < ActionController::Base

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= GithubUser.find(session[:user_id])
  end

  def current_user=(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
  end
end
