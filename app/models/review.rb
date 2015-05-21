class Review < ActiveRecord::Base

  belongs_to :pull_request
  belongs_to :github_user

  def approve
    update_attribute(:status, :approved)
  end

  def reject
    update_attribute(:status, :rejected)
  end

  def github_username
    github_user.github_username
  end
end
