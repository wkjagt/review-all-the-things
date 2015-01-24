class GithubUser < ActiveRecord::Base

  has_many :pull_requests
  has_many :reviews

  def self.from_github(params)
    user = GithubUser.find_by(github_username: params[:login])
    return user if user.present?

    GithubUser.create(github_username: params[:login])
  end

  def open_pull_request(params, repository)
    pull_requests.create(
      title: params[:title],
      url: params[:html_url],
      body: params[:body],
      repository: repository
    )
  end

  def reviews?(pull_request)
    reviews.find_by(pull_request: pull_request).present?
  end
end
