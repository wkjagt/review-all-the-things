class SessionController < ApplicationController

  def create
    username = request.env['omniauth.auth']['extra']['raw_info']['login']
    self.current_user = GithubUser.from_github(username)

    redirect_to controller: :users, action: :show, user: username
  end
end
