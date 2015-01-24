require 'test_helper'

class GithubEventsControllerTest < ActionController::TestCase

  test "creates the @event object before any action" do
    json = get_json("pull_request_creation.json")
    @request.headers["X-Github-Event"] = "pull_request"
    raw_post :webhook, json

    event = assigns(:event)

    assert_response :ok
    assert_equal Event, event.class
  end

  test "creates non existing resources for an open pull request event" do
    json = get_json("pull_request_creation.json")
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "PullRequest.count", +1 do
      raw_post :webhook, json
    end
    assert_response :ok
  end

  test "creates user objects for each mention in an opened pull request" do
    json = get_json("pull_request_creation.json")
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "GithubUser.count", +1 do
      raw_post :webhook, json
    end
    assert_response :ok
  end

  test "creates reviews for each mention in an opened pull request" do
    json = get_json("pull_request_creation.json")
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "Review.count", +2 do
      raw_post :webhook, json
    end
  end
end
