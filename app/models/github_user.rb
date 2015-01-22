class GithubUser < ActiveRecord::Base

  has_many :pull_requests
  has_many :reviewers

  def self.from_github(params)
    pp  params
    begin
      GithubUser.find_by!(github_username: params["login"])
    rescue ActiveRecord::RecordNotFound
      GithubUser.create(github_username: params["login"])
    end
  end

  def open_pull_request(params, repository)
    self.pull_requests.create(
      title: params["title"],
      url: params["html_url"],
      body: params["body"],
      repository: repository
    )
  end

  def reviews?(pull_request)
    reviewers.find_by(pull_request: pull_request)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
