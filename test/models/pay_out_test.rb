require 'test_helper'

class PayOutTest < ActiveSupport::TestCase
  test 'belongs to dividend association' do
    assert_equal dividends(:pay_out_complete), pay_outs(:one).dividend
  end
end
