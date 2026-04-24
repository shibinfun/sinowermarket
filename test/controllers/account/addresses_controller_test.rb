require "test_helper"

class Account::AddressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user)
    sign_in @user
  end

  test "should redirect from new when address limit reached" do
    @user.addresses.destroy_all
    3.times do |i|
      @user.addresses.create!(
        name: "Address #{i}",
        phone: "123",
        province: "P",
        city: "C",
        detail_address: "D"
      )
    end

    get new_account_address_url
    assert_redirected_to account_addresses_url
    assert_equal "You can only have up to 3 addresses.", flash[:alert]
  end

  test "should not create address when limit reached" do
    @user.addresses.destroy_all
    3.times do |i|
      @user.addresses.create!(
        name: "Address #{i}",
        phone: "123",
        province: "P",
        city: "C",
        detail_address: "D"
      )
    end

    assert_no_difference("Address.count") do
      post account_addresses_url, params: { address: { name: "New", phone: "123", province: "P", city: "C", detail_address: "D" } }
    end
    assert_response :unprocessable_entity
  end
end
