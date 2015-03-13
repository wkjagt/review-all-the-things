class PullRequest  < ActiveRecord::Base
  attr_reader :parsed_body

  after_create :parse_body

  belongs_to :github_user
  belongs_to :repository

  has_many :reviews  do
    def create_or_reset_for(github_user)
      if review = self.find_by(github_user: github_user)
        review.update_attribute(:status, :to_review)
      else
        self.create(github_user: github_user)
      end
    end
  end

  def parse_body
    @parsed_body = Values::Body.new(body)
  end

  def close
    update_attribute(:status, :closed)
  end
end
