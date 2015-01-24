require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "correctly instantiates when getting an open pull request event" do
    event = Event.new("pull_request", payload_for("pull_request_creation.json"))

    assert_equal :pull_request_opened, event.name
    assert_equal "https://github.com/wkjagt/rails_incoming_mail/pull/10", event.pull_request_url
    assert_raises(ArgumentError) do
      puts event.comment_hash
    end
    assert_equal "wkjagt", event.pull_request_hash[:user][:login]
  end

  test "correctly instantiates when getting a closed pull request event" do
    event = Event.new("pull_request", payload_for("pull_request_closed.json"))

    assert_equal :pull_request_closed, event.name
    assert_equal "https://github.com/wkjagt/rails_incoming_mail/pull/10", event.pull_request_url
    assert_raises(ArgumentError) do
      event.comment_hash
    end
    assert_equal "wkjagt", event.pull_request_hash[:user][:login]
  end

  test "correctly instantiates when getting a pull request comment event" do
    event = Event.new("issue_comment", payload_for("pull_request_comment.json"))

    assert_equal :pull_request_comment, event.name
    assert_equal "https://github.com/wkjagt/rails_incoming_mail/pull/10", event.pull_request_url
    assert_nothing_raised(ArgumentError) do
      comment_hash = event.comment_hash
    end
    assert_equal "wkjagt", event.comment_hash[:user][:login]

  end
end
