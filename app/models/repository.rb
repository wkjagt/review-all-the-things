class Repository < ActiveRecord::Base
  def self.from_github(params)
    begin
      Repository.find_by!(github_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      Repository.create(github_id: params[:id], name: params[:full_name], url: params[:html_url])
    end
  end
end
