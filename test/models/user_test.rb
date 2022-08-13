require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users :one
    @new_user = User.new(email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "password should be present (nonblank)" do
    @new_user.password = @new_user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @new_user.password = @new_user.password_confirmation = "a" * 5
    assert_not @new_user.valid?
  end
end
