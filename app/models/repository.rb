class Repository < ActiveRecord::Base
  def self.from_github(params)
    begin
      Repository.find_by!(url: params["html_url"])
    rescue ActiveRecord::RecordNotFound
      Repository.create(name: params["full_name"], url: params["html_url"])
    end
  end
end
