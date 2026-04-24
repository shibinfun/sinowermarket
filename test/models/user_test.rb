require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user)
  end

  test "should track sign in details" do
    assert_equal 0, @user.sign_in_count
    
    # Simulate sign in
    @user.update!(
      sign_in_count: 1,
      current_sign_in_at: Time.current,
      current_sign_in_ip: "127.0.0.1"
    )
    
    assert_equal 1, @user.sign_in_count
    assert_not_nil @user.current_sign_in_at
    assert_equal "127.0.0.1", @user.current_sign_in_ip
  end

  test "should lock account after maximum attempts" do
    # Clear any previous failed attempts
    @user.update!(failed_attempts: 0, locked_at: nil)
    
    # Fail 5 times (based on our config)
    5.times do
      @user.failed_attempts += 1
      if @user.failed_attempts >= 5
        @user.lock_access!
      end
      @user.save!
    end
    
    assert @user.access_locked?
    assert_not_nil @user.locked_at
  end

  test "should timeout session" do
    # This is more of a Devise config check, but we can verify the timeout_in value
    assert_equal 1.hour, User.timeout_in
  end

  test "should validate password complexity" do
    user = User.new(email: "test@example.com")
    
    # Too short
    user.password = "1234567"
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"

    # Weak password
    user.password = "password123"
    assert_not user.valid?
    assert_includes user.errors[:password], "强度太弱。请尝试添加数字、符号或大写字母，并避免使用常见词汇。"

    # Strong password
    user.password = "Tr0ub4dor&3!"
    user.valid?
    assert_empty user.errors[:password]
  end
end
