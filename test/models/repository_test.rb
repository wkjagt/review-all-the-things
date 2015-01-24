require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  test "gets an existing repo from the by its url" do
    fixture = repositories(:my_repo)
    assert_no_difference "Repository.count" do
      assert fixture.id == Repository.from_github(html_url: fixture[:url]).id
    end
  end

  test "creates a new reposisory if it doesn't exist" do
    assert_difference "Repository.count", +1 do
      Repository.from_github(html_url: "https://www.github.com/wkjagt/myrepo2", full_name: "name")
    end
  end
end
