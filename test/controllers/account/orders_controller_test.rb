require "test_helper"

class Account::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user)
    @order = orders(:one)
  end

  test "should get index when logged in" do
    sign_in @user
    get account_orders_url
    assert_response :success
    assert_select "h1", "My Orders"
    assert_select "p", text: "##{@order.id}"
  end

  test "should redirect index when not logged in" do
    get account_orders_url
    assert_redirected_to new_user_session_url
  end

  test "should show order when logged in" do
    sign_in @user
    get account_order_url(@order)
    assert_response :success
    assert_select "h1", "Order ##{@order.id}"
  end

  test "should not show other user's order" do
    @other_user = users(:admin)
    sign_in @other_user
    get account_order_url(@order) # @order is orders(:one), belongs to :user
    assert_response :not_found
  end
end
