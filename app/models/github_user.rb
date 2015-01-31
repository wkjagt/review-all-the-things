class GithubUser < ActiveRecord::Base

  has_many :pull_requests
  has_many :reviews

  def self.from_github(username)
    user = GithubUser.find_by(github_username: username)
    return user if user.present?

    GithubUser.create(github_username: username)
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

  def prs_to_review
    prs_for_review_by_status(:to_review)
  end

  def rejected_prs
    prs_for_review_by_status(:rejected)
  end

  def approved_prs
    prs_for_review_by_status(:approved)
  end

  private

  def prs_for_review_by_status(status)
    prs = []
    reviews.where(status: status).each do |review|
      prs << review.pull_request
    end

    prs
  end
end
