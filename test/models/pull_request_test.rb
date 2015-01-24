require 'test_helper'

class PullRequestTest < ActiveSupport::TestCase
  test "closing a pull request will update its status to closed" do
    pr = pull_requests(:my_pr)
    pr.close
    assert_equal "closed", pr.status
  end
end
