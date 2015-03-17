require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "the user feed doesn't contain any secret information" do
    user = github_users(:some_other_user)
    ApplicationController.any_instance.stubs(current_user: user)

    get :user_log, { user: user.github_username, "application-secret" => user.secret }

    response_user = JSON.parse(response.body).first["github_user"]
    assert_equal "wkjagt", response_user.delete("github_username")
    assert_empty response_user
  end

  test "the user feed contains only contains open prs" do
    willem = github_users(:willem)
    ApplicationController.any_instance.stubs(current_user: willem)

    get :user_log, { user: willem.github_username, "application-secret" => willem.secret }

    JSON.parse(response.body).each do |pr|
      assert_equal pr["status"], "open"
    end
  end
end
