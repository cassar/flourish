require 'test_helper'

class AmountTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), amounts(:one).distribution
  end
end
