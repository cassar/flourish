require 'test_helper'

module Admin
  class MembersHelperTest < ActionView::TestCase
    test 'paypalmeid present' do
      assert_equal '💰', paypalmeid_emoji('a_paypalme_id')
    end

    test 'paypalmeid not present' do
      assert_equal '🚫', paypalmeid_emoji(nil)
    end
  end
end
