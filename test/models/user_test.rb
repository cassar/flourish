require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:robert), users(:one).member

    users(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      members(:robert).reload
    end
  end
end
