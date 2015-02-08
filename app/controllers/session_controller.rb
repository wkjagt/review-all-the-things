class SessionController < ApplicationController

  def create
    username = request.env['omniauth.auth']['extra']['raw_info']['login']
    self.current_user = GithubUser.from_github(username, token: request.env['omniauth.auth']['credentials']['token'])

    redirect_to controller: :users, action: :show, user: username
  end

  def destroy
    logout
    redirect_to '/'
  end
end
