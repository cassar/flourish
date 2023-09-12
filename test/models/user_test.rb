require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'associations' do
    assert_equal members(:active), users(:one).member

    users(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      members(:active).reload
    end
  end
end
