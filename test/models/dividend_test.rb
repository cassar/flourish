require 'test_helper'

class DividendTest < ActiveSupport::TestCase
  test 'belongs to distribution association' do
    assert_equal distributions(:one), dividends(:one).distribution
  end

  test 'belongs to member association' do
    assert_equal members(:active), dividends(:one).member
  end

  test 'created_at_formatted' do
    assert_equal '8th Nov 2023', dividends(:one).created_at_formatted
  end
end
