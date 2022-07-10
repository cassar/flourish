require "test_helper"

class DividendService::DistributionTest < ActiveSupport::TestCase
  test "#dividend_to_pay? when dividend is greater than the minimum dividend" do
    assert DividendService::Distribution.new(
      available_funds: 6,
      minimum_dividend: 5,
      member_count: 1,
    ).dividend_to_pay?
  end

  test "#dividend_to_pay? when dividend is equal to the minimum dividend" do
    assert DividendService::Distribution.new(
      available_funds: 5,
      minimum_dividend: 5,
      member_count: 1,
    ).dividend_to_pay?
  end

  test "#dividend_to_pay? when dividend is less than than minimum dividend" do
    assert_not DividendService::Distribution.new(
      available_funds: 4,
      minimum_dividend: 5,
      member_count: 1,
    ).dividend_to_pay?
  end

  test "#dividend when there is a dividend to pay" do
    distribution = DividendService::Distribution.new(
      available_funds: 10,
      minimum_dividend: 5,
      member_count: 2,
    )

    assert distribution.dividend_to_pay?
    assert_equal 5, distribution.dividend
  end

  test "#dividend when there are no members" do
    distribution = DividendService::Distribution.new(
      available_funds: 10,
      minimum_dividend: 5,
      member_count: 0,
    )
    assert_nothing_raised do
      assert_equal 0, distribution.dividend
    end
  end
end
