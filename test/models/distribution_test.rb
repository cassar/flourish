require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'has many dividends' do
    assert_includes distributions(:one).dividends, dividends(:one)

    distributions(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end

  test 'dividend amount formatted' do
    assert_equal 500, distributions(:one).dividend_amount_in_base_units

    assert_equal '$5.00', distributions(:one).dividend_amount_formatted
  end
end
