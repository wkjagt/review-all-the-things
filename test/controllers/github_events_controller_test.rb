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

  test "a comment from a user that is not a reviewer gets ignored" do
    params = {
      action: :created,
      issue: {
        pull_request: {
          html_url: "https://www.github.com/wkjagt/myrepo/pulls/144"
        },
      },
      comment: {
        body: "commenting with  a :+1: ",
        user: {
          login: "not_a_reviewer"
        }
      },
      repository: {
        html_url: "https://www.github.com/wkjagt/myrepo"
      },
      sender: {
        login: "not_a_reviewer"
      }
    }

    json = params.to_json

    @request.headers["X-Github-Event"] = "issue_comment"
    raw_post :webhook, json

    Comment.any_instance.expects(:score).never
  end

  test "a positive comment from a reviewer approves the pr" do
    review = reviews(:my_review)
    params = {
      action: :created,
      issue: {
        pull_request: {
          html_url: review.pull_request.url
        },
      },
      comment: {
        body: "commenting with  a :+1: ",
        user: {
          login: review.github_user.github_username
        }
      },
      repository: {
        html_url: review.pull_request.repository.url
      },
      sender: {
        login: review.github_user.github_username
      }
    }
    json = params.to_json

    @request.headers["X-Github-Event"] = "issue_comment"
    raw_post :webhook, json

    assert_equal "approved", review.reload.status
  end
end
