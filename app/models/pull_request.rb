class PullRequest  < ActiveRecord::Base
  attr_reader :parsed_body

  after_create :parse_body

  belongs_to :github_user
  belongs_to :repository

  has_many :reviewers

  def parse_body
    @parsed_body = Values::Body.new(body)
  end
end
