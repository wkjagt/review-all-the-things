require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "a comment has a score bases on its positive and negative emoticons" do
    comment = Comment.new(user: {login: "wkjagt"}, body: "looks good :shipit: :santa: :+1:")
    assert_equal 3, comment.score
    assert comment.approved?
    refute comment.rejected?
  end

  test "a negative comment is considered a rejection" do
    comment = Comment.new(user: {login: "wkjagt"}, body: "wow your code sucks :-1:")
    assert_equal -1, comment.score
    refute comment.approved?
    assert comment.rejected?
  end

  test "a neutral comment is neither a rejection nor an approval" do
    comment = Comment.new(user: {login: "wkjagt"}, body: "let me think about this")
    assert_equal 0, comment.score
    refute comment.approved?
    refute comment.rejected?
  end

  test "a comment from an unknown commenter creates a user object" do
    assert_difference "GithubUser.count", +1 do
      Comment.new(user: {login: "i_dont_exist"}, body: "First time comment W00T!")
    end
  end

  test "a comment from a known commenter doesnt create a user object" do
    assert_no_difference "GithubUser.count" do
      Comment.new(user: {login: "wkjagt"}, body: "Me again...")
    end
  end
end
