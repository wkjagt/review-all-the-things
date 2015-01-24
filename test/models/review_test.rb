require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "a review can be approved" do
    review = reviews(:my_review)
    review.approve
    assert_equal "approved", review.status
  end

  test "a review can be rejected" do
    review = reviews(:my_review)
    review.reject
    assert_equal "rejected", review.status
  end

end
