class GithubUser < ActiveRecord::Base

  has_many :pull_requests
  has_many :reviews

  before_create :create_secret

  def self.from_github(username, *args)
    user = GithubUser.find_by(github_username: username)
    return user if user.present?

    GithubUser.create(github_username: username, access_token: args.extract_options![:token])
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

  def unmerged_prs
    pull_requests.where(status: :open)
                 .includes(:reviews)
  end

  def feed
    {
      to_review: prs_to_review.as_json(include: {
                                                  github_user: { only: :github_username },
                                                  repository: { only: [:url, :name] }
                                                }),
      unmerged_prs: unmerged_prs.as_json(include: {
                                                    repository: { only: [:url, :name] },
                                                    reviews: { methods: [:github_username]},
                                                  })
    }
  end

  private

  def create_secret
    self.secret = SecureRandom.hex
  end

  def prs_for_review_by_status(status)
    reviews.where(status: status)
           .includes(:pull_request)
           .where(pull_requests: { status: "open" })
           .map(&:pull_request)
  end
end
