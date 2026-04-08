require "test_helper"

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @sku = skus(:sku_electronics)
  end

  test "user can complete the whole checkout process" do
    sign_in @user

    # 1. Add item to cart
    post cart_items_path, params: { sku_id: @sku.id, quantity: 1 }
    follow_redirect!
    assert_match @sku.name, response.body

    # 2. Go to checkout page
    get new_order_path
    assert_response :success

    # 3. Submit order
    assert_difference "Order.count", 1 do
      assert_difference "OrderItem.count", 1 do
        post orders_path, params: {
          order: {
            name: "John Doe",
            phone: "123456789",
            address: "123 Street, City"
          }
        }
      end
    end

    # 4. Redirect to order show page
    follow_redirect!
    assert_select "h1", text: /Order #\d+/
    assert_select "p", text: /John Doe/
    assert_select "span", text: "Pending"

    # 5. Check if cart is empty
    get cart_path
    assert_select "h2", text: "Your cart is empty"

    # 6. Simulate payment
    order = Order.last
    post pay_order_path(order)
    follow_redirect!
    assert_select "span", text: "Paid"
  end

  test "user can cancel a pending order" do
    sign_in @user
    
    # 1. Create a pending order
    post orders_path, params: {
      order: {
        name: "John Doe",
        phone: "123456789",
        address: "123 Street, City"
      }
    }
    order = Order.last
    assert_equal "pending", order.status
    
    # 2. Cancel the order
    post cancel_order_path(order)
    follow_redirect!
    
    # 3. Verify it's cancelled
    assert_select "span", text: "Cancelled"
    assert_equal "cancelled", order.reload.status
    
    # 4. Try to pay a cancelled order (should fail/redirect)
    post pay_order_path(order)
    follow_redirect!
    assert_match "This order cannot be paid.", flash[:alert]
    assert_equal "cancelled", order.reload.status
  end

  test "user cannot cancel a paid order" do
    sign_in @user
    
    # 1. Create and pay an order
    post orders_path, params: {
      order: {
        name: "John Doe",
        phone: "123456789",
        address: "123 Street, City"
      }
    }
    order = Order.last
    post pay_order_path(order)
    assert_equal "paid", order.reload.status
    
    # 2. Try to cancel
    post cancel_order_path(order)
    follow_redirect!
    
    # 3. Should still be paid
    assert_match "This order cannot be cancelled.", flash[:alert]
    assert_equal "paid", order.reload.status
  end

  test "guest must sign in before checkout" do
    # 1. Add item as guest
    post cart_items_path, params: { sku_id: @sku.id, quantity: 1 }
    
    # 2. Try to go to checkout
    get new_order_path
    assert_redirected_to new_user_session_path
  end
end
