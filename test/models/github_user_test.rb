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
end
