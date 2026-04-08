require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:user)
    @order = orders(:one) # Status is 'paid'
    @pending_order = orders(:two) # Status is 'pending'
  end

  test "admin should get index" do
    sign_in @admin
    get admin_orders_url
    assert_response :success
    assert_select "h1", "All Orders"
  end

  test "admin should show order" do
    sign_in @admin
    get admin_order_url(@order)
    assert_response :success
    assert_select "h1", "Order ##{@order.id}"
  end

  test "admin should ship order" do
    sign_in @admin
    post ship_admin_order_url(@order)
    assert_redirected_to admin_order_url(@order)
    @order.reload
    assert_equal "shipped", @order.status
  end

  test "admin should complete order" do
    sign_in @admin
    # First ship it
    @order.update(status: "shipped")
    
    post complete_admin_order_url(@order)
    assert_redirected_to admin_order_url(@order)
    @order.reload
    assert_equal "delivered", @order.status
  end

  test "admin should cancel order" do
    sign_in @admin
    post cancel_admin_order_url(@order)
    assert_redirected_to admin_order_url(@order)
    @order.reload
    assert_equal "cancelled", @order.status
  end

  test "non-admin should not access admin orders" do
    sign_in @user
    get admin_orders_url
    assert_redirected_to root_url
  end
end
