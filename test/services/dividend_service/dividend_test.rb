require "test_helper"

class DividendService::DividendTest < ActiveSupport::TestCase
  setup do
    @date = Date.parse("2020 Dec 4th")
    Date.stubs(:today).returns(@date).once
    TotalContributionsService.stubs(:amount).returns(500)
  end

  test ".next_dividend_amount" do
    assert_equal "$250.00", DividendService::Dividend.next_dividend_amount
  end

  test ".next_dividend_date" do
    assert_equal @date + 1.weeks, DividendService::Dividend.next_dividend_date
  end
end
