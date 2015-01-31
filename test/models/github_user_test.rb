require 'test_helper'

class GithubUserTest < ActiveSupport::TestCase
  test "loads or creates a github user based on their github username" do
    assert_no_difference "GithubUser.count" do
      GithubUser.from_github(login: "wkjagt")
    end

    assert_difference "GithubUser.count", +1 do
      GithubUser.from_github(login: "this_one_doesnt_exist")
    end

    assert_no_difference "GithubUser.count" do
      GithubUser.from_github(login: "this_one_doesnt_exist")
    end
  end

  test "opening a pull request will create a pull request in the database" do
    params = {
      title: "Fixing things",
      html_url: "https://www.github.com/wkjagt/myrepo/pulls/144",
      body: "please review this",
    }
    user = github_users(:willem)
    repo = repositories(:my_repo)

    PullRequest::ActiveRecord_Associations_CollectionProxy
      .any_instance.expects(:create)
      .with(title: params[:title], url: params[:html_url], body: params[:body], repository: repo)
      .once

    user.open_pull_request(params, repo)
  end

  test "#prs_to_review returns pull requests this user needs to review" do
    user = github_users(:willem)
    to_review = user.prs_to_review
    assert_equal 1, to_review.count
    assert_equal PullRequest, to_review.first.class
    assert_equal "open", to_review.first.status
  end

  test "#rejected_prs returns pull requests that are rejected by this user" do
    user = github_users(:willem)
    to_review = user.rejected_prs
    assert_equal 1, to_review.count
    assert_equal PullRequest, to_review.first.class
    assert_equal "open", to_review.first.status
  end

  test "#approved_prs returns pull requests that are approved by this user" do
    user = github_users(:willem)
    to_review = user.approved_prs
    assert_equal 1, to_review.count
    assert_equal PullRequest, to_review.first.class
    assert_equal "open", to_review.first.status
  end

end
