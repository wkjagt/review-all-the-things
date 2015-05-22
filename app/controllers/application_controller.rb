class ApplicationController < ActionController::Base

  after_action :allow_iframe

  private

  def current_user

    if user_id = session[:user_id]
      @current_user ||= GithubUser.find_by(id: user_id)
    elsif params["application-secret"] && params["user"]
      @current_user ||= GithubUser.find_by(github_username: params["user"], secret: params["application-secret"])
    end
  end

  def current_user=(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
