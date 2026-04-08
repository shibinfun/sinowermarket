require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index and not show category banner" do
    get home_index_url
    assert_response :success
    assert_select '[data-controller="category-tabs"]', count: 0
  end
end
