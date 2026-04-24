require "test_helper"

class AddressTest < ActiveSupport::TestCase
  setup do
    @user = users(:user)
  end

  test "should not allow more than 3 addresses per user" do
    # Clear existing addresses to be sure
    @user.addresses.destroy_all

    # Create 3 addresses
    3.times do |i|
      Address.create!(
        user: @user,
        name: "Address #{i}",
        phone: "1234567890",
        province: "Prov",
        city: "City",
        detail_address: "Detail"
      )
    end

    assert_equal 3, @user.addresses.count

    # Try to create the 4th address
    fourth_address = Address.new(
      user: @user,
      name: "Address 4",
      phone: "1234567890",
      province: "Prov",
      city: "City",
      detail_address: "Detail"
    )

    assert_not fourth_address.valid?
    assert_includes fourth_address.errors[:base], "You can only have up to 3 addresses"
  end

  test "should allow updating existing addresses even if at limit" do
    @user.addresses.destroy_all
    
    address = Address.create!(
      user: @user,
      name: "Original",
      phone: "1234567890",
      province: "Prov",
      city: "City",
      detail_address: "Detail"
    )
    
    # Create 2 more to reach limit
    2.times { |i| Address.create!(user: @user, name: "Other #{i}", phone: "123", province: "P", city: "C", detail_address: "D") }
    
    assert_equal 3, @user.addresses.count
    
    address.name = "Updated Name"
    assert address.valid?, "Should be valid when updating existing address"
    assert address.save
  end
end
