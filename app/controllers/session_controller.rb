class SessionController < ApplicationController

  def create
    access_token = request.env['omniauth.auth']['credentials']['token']
    username = request.env['omniauth.auth']['extra']['raw_info']['login']

    if organization = Rails.configuration.github_webhooks_validate_organization
      return destroy unless Octokit::Client.new(:access_token => access_token).organization_member?(organization, username)
    end

    self.current_user = GithubUser.from_github(username, token: access_token)

    redirect_to controller: :users, action: :show
  end

  def destroy
    logout
    redirect_to '/'
  end
end
