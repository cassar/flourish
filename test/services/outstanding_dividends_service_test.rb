require 'test_helper'

class OutstandingDividendsServiceTest < ActiveSupport::TestCase
  test 'total_amount_in_base_units' do
    assert_equal(1_000, Dividend.issued.sum { |dividend| dividend.distribution.dividend_amount_in_base_units })
    assert_equal(500, Dividend.pending_pay_out.sum { |dividend| dividend.distribution.dividend_amount_in_base_units })

    assert_equal 1_500, OutstandingDividendsService.total_amount_in_base_units
  end
end
