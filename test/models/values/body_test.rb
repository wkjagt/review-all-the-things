require 'test_helper'

class Values::BodyTest < ActiveSupport::TestCase
  def setup
    Octokit::Client.any_instance.stubs(:organization_member?).returns(true)
  end

  test "using mentions, causes a github user to be created for each if it doesn't exist" do
    assert_difference "GithubUser.count", +2 do
      Values::Body.new("please review @wkjagt, @user_a and @user_b")
    end
  end

  test "it returns the mentions as user objects" do
    body = Values::Body.new("please review @wkjagt, @user_a and @user_b")
    mentions = body.mentions
    assert_equal 3, mentions.length
    assert_equal "wkjagt", mentions[0].github_username
    assert_equal "user_a", mentions[1].github_username
    assert_equal "user_b", mentions[2].github_username
  end

  test "it returns emoticons from the content" do
    body = Values::Body.new("looks good :shipit: :santa: :+1:")
    assert_equal [":shipit:", ":santa:", ":+1:"], body.emoticons
  end
end
