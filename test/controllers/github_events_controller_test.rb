require 'test_helper'

class GithubEventsControllerTest < ActionController::TestCase

  def setup
    Rails.configuration.github_webhooks_validate_secret = false
    Octokit::Client.any_instance.stubs(:organization_member?).returns(true)
  end

  test "creates the @event object before any action" do
    @request.headers["X-Github-Event"] = "pull_request"
    raw_post :webhook, get_json("pull_request_creation.json")

    event = assigns(:event)

    assert_response :ok
    assert_equal Event, event.class
  end

  test "creates non existing resources for an open pull request event" do
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "PullRequest.count", +1 do
      raw_post :webhook, get_json("pull_request_creation.json")
    end
    assert_response :ok
  end

  test "creates user objects for each mention in an opened pull request" do
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "GithubUser.count", +1 do
      raw_post :webhook, get_json("pull_request_creation.json")
    end
    assert_response :ok
  end

  test "creates reviews for each mention in an opened pull request" do
    @request.headers["X-Github-Event"] = "pull_request"

    assert_difference "Review.count", +2 do
      raw_post :webhook, get_json("pull_request_creation.json")
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
        body: "commenting with  a :+1: @someunknowndude",
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

    @request.headers["X-Github-Event"] = "issue_comment"
    assert_no_difference 'Review.count' do
      raw_post :webhook, params.to_json
    end
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
    @request.headers["X-Github-Event"] = "issue_comment"
    raw_post :webhook, params.to_json

    assert_equal "approved", review.reload.status
  end

  test "it validates the secret from GitHub" do
    Rails.configuration.github_webhooks_validate_secret = true

    review = reviews(:my_review)
    secret = Rails.configuration.github_webhooks_secret
    params = {
      action: :this_doesnt_exist,
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
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, json)
    @request.headers['HTTP_X_HUB_SIGNATURE'] = signature
    raw_post :webhook, json

    assert_equal 200, response.code.to_i
  end

  test "a pr comment from the owner can add a reviewer to the pr" do
    pr = pull_requests(:my_pr)
    new_reviewer = github_users(:grumpy_dev)

    params = {
      action: :created,
      issue: {
        pull_request: {
          html_url: pr.url
        },
      },
      comment: {
        body: "please review this thing @#{new_reviewer.github_username}",
        user: {
          login: pr.github_user.github_username
        }
      },
      repository: {
        html_url: pr.repository.url
      },
      sender: {
        login: pr.github_user.github_username
      }
    }

    @request.headers["X-Github-Event"] = "issue_comment"

    pr.reviews.destroy_all
    assert_difference 'Review.count', +1 do
      raw_post :webhook, params.to_json
    end
    assert pr.reviews.find_by(github_user_id: new_reviewer.id).present?
  end

  test "a pr comment from the owner can reset a review to to_review" do
    pr = pull_requests(:my_pr)
    pr.reviews.each { |review| review.approve }
    pr.reload

    params = {
      action: :created,
      issue: {
        pull_request: {
          html_url: pr.url
        },
      },
      comment: {
        body: "please review this thing @#{pr.reviews.first.github_user.github_username}",
        user: {
          login: pr.github_user.github_username
        }
      },
      repository: {
        html_url: pr.repository.url
      },
      sender: {
        login: pr.github_user.github_username
      }
    }

    @request.headers["X-Github-Event"] = "issue_comment"

    assert_difference 'pr.reviews.first.github_user.prs_to_review.count', +1 do
      assert_no_difference 'GithubUser.count' do
        raw_post :webhook, params.to_json
      end
    end
    assert pr.reviews.find_by(github_user_id: pr.reviews.first.github_user.id).present?
  end
end
