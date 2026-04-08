require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sku = skus(:sku_electronics)
  end

  test "should get show and not show category banner" do
    get cart_url
    assert_response :success
    assert_select '[data-controller="category-tabs"]', count: 0
  end

  test "should add item to cart" do
    assert_difference("CartItem.count") do
      post cart_items_url, params: { sku_id: @sku.id, quantity: 1 }
    end
    assert_redirected_to skus_path
    follow_redirect!
    assert_match "Added #{@sku.name} to cart.", response.body
  end

  test "should update cart item quantity" do
    post cart_items_url, params: { sku_id: @sku.id, quantity: 1 }
    cart_item = CartItem.last
    
    patch cart_item_url(cart_item), params: { cart_item: { quantity: 5 } }
    assert_redirected_to cart_path
    assert_equal 5, cart_item.reload.quantity
  end

  test "should remove item from cart" do
    post cart_items_url, params: { sku_id: @sku.id, quantity: 1 }
    cart_item = CartItem.last
    
    assert_difference("CartItem.count", -1) do
      delete cart_item_url(cart_item)
    end
    assert_redirected_to cart_path
  end
end
