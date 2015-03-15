require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "the user feed doesn't contain any secret information" do
    user = github_users(:some_other_user)
    ApplicationController.any_instance.stubs(current_user: user)

    get :user_log, { user: user.github_username, "application-secret" => user.secret }

    require "pry";binding.pry;:something
    response_user = JSON.parse(response.body).first["github_user"]
    assert_equal "wkjagt", response_user.delete("github_username")
    assert_empty response_user
  end
end
