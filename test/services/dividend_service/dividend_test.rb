require "test_helper"

class DividendService::DividendTest < ActiveSupport::TestCase
  setup do
    date = Date.parse("2020 Dec 4th")
    Date.stubs(:today).returns(date).once
  end

  test ".next_dividend_amount" do
    dividend = DividendService::Dividend.new(
      total_contributions: 500,
      member_count: 2
    )

    assert_equal "$250.00", dividend.amount_formatted
  end

  test ".next_dividend_amount when no contributions" do
    dividend = DividendService::Dividend.new(
      total_contributions: 0,
      member_count: 2
    )

    assert_nothing_raised do
      assert_equal "$0.00", dividend.amount_formatted
    end
  end

  test ".next_dividend_date" do
    dividend = DividendService::Dividend.new(
      total_contributions: 500,
      member_count: 2
    )

    assert_equal "December 11th, 2020", dividend.date_formatted
  end

  test ".next_dividend_date when no contributions" do
    dividend = DividendService::Dividend.new(
      total_contributions: 0,
      member_count: 2
    )

    assert_nothing_raised do
      assert_equal 'never', dividend.date_formatted
    end
  end
end
