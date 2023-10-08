require 'test_helper'

module DividendService
  class NextDividendDateCompareTest < ActiveSupport::TestCase
    NextDividend = Struct.new(:date, :date_formatted)

    def setup
      @current_next_dividend = NextDividend.new(Date.new(2023, 10, 1), 'October 1, 2023')
      @future_next_dividend = NextDividend.new(Date.new(2023, 10, 15), 'October 15, 2023')
    end

    def test_dividend_date_brought_forward
      compare = DividendService::NextDividendDateCompare.new(
        current_next_dividend: @current_next_dividend,
        future_next_dividend: @future_next_dividend
      )

      assert_equal('Push back the dividend date by 14 days to October 15, 2023.', compare.formatted)
    end

    def test_dividend_date_pushed_back
      @future_next_dividend.date = Date.new(2023, 9, 15)
      compare = DividendService::NextDividendDateCompare.new(
        current_next_dividend: @current_next_dividend,
        future_next_dividend: @future_next_dividend
      )

      assert_equal('Bring forward the dividend date by 16 days to October 15, 2023.', compare.formatted)
    end

    def test_dividend_date_unchanged
      @future_next_dividend.date = Date.new(2023, 10, 1)
      compare = DividendService::NextDividendDateCompare.new(
        current_next_dividend: @current_next_dividend,
        future_next_dividend: @future_next_dividend
      )

      assert_equal('Leave the next dividend date unchanged at October 15, 2023.', compare.formatted)
    end
  end
end
