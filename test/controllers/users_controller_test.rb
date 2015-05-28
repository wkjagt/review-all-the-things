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
end
