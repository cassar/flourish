require "test_helper"

class DividendService::DividendTest < ActiveSupport::TestCase
  setup do
    date = Date.parse("2020 Dec 4th")
    Date.stubs(:today).returns(date).once
  end

  test ".next_dividend_amount" do
    TotalContributionsService.stubs(:amount).returns(500)

    assert_equal "$250.00", DividendService::Dividend.next_dividend_amount
  end

  test ".next_dividend_amount when no contributions" do
    TotalContributionsService.stubs(:amount).returns(0)

    assert_nothing_raised do
      assert_equal "$0.00", DividendService::Dividend.next_dividend_amount
    end
  end

  test ".next_dividend_date" do
    TotalContributionsService.stubs(:amount).returns(500)

    assert_equal "December 11th, 2020",
      DividendService::Dividend.next_dividend_date
  end

  test ".next_dividend_date when no contributions" do
    TotalContributionsService.stubs(:amount).returns(0)

    assert_nothing_raised do
      assert_equal 'never', DividendService::Dividend.next_dividend_date
    end
  end
end
