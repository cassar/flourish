require "test_helper"

class DividendService::DividendTest < ActiveSupport::TestCase
  test ".next_dividend_amount" do
    common_dividend_stubs
    assert_equal 250, DividendService::Dividend.next_dividend_amount
  end

  test ".next_dividend_date" do
    common_dividend_stubs
    assert_equal @date + 1.weeks, DividendService::Dividend.next_dividend_date
  end

  def common_dividend_stubs
    @date = Date.parse("2020 Dec 4th")
    Date.stubs(:today).returns(@date).once
  end
end
