require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "#user_log structure" do
    willem = github_users(:willem)
    get :user_log, { user: willem.github_username, "application-secret" => willem.secret }

    JSON.parse(response.body)['to_review'].each do |pr|
      assert_equal pr["status"], "open"
    end
    JSON.parse(response.body)['unmerged_prs'].each do |pr|
      assert_equal pr["status"], "open"
    end
  end

  test "#user_log returns :forbidden when no current_user" do
    willem = github_users(:willem)
    get :user_log, { user: willem.github_username, "application-secret" => 'wrong' }
  end

  test "#show redirects to / if no user if logged in" do
    get :show
    assert_redirected_to('/')
  end

  test "#show assigns @user when logged in" do
    willem = github_users(:willem)
    ApplicationController.any_instance.stubs(current_user: github_users(:willem))
    get :show

    assert_response :success
    assert_equal assigns(:user), willem
  end
end
