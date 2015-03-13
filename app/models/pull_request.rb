class PullRequest  < ActiveRecord::Base
  attr_reader :parsed_body

  after_create :parse_body

  belongs_to :github_user
  belongs_to :repository

  has_many :reviews

  def parse_body
    @parsed_body = Values::Body.new(body)
  end

  def close
    update_attribute(:status, :closed)
  end
end
