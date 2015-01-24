class Repository < ActiveRecord::Base
  def self.from_github(params)
    repo = Repository.find_by(url: params[:html_url])
    return repo if repo.present?

    Repository.create(name: params[:full_name], url: params[:html_url])
  end
end
