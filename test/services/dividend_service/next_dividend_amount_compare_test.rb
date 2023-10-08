require 'test_helper'

module DividendService
  class NextDividendAmountCompareTest < ActiveSupport::TestCase
    CurrentNextDividend = Struct.new(:amount)
    FutureNextDividend = Struct.new(:amount) do
      def amount_formatted
        "$#{amount}.00"
      end
    end

    def setup
      @current_next_dividend = CurrentNextDividend.new(100)
      @future_next_dividend = FutureNextDividend.new(150)
      @compare = DividendService::NextDividendAmountCompare.new(
        current_next_dividend: @current_next_dividend,
        future_next_dividend: @future_next_dividend
      )
    end

    def test_formatted_returns_correct_string_for_increase
      expected_string = 'Increase the dividend by $50.00 to $150.00.'
      assert_equal expected_string, @compare.formatted
    end

    def test_formatted_returns_correct_string_for_decrease
      @current_next_dividend.amount = 200
      expected_string = 'Decrease the dividend by $50.00 to $150.00.'
      assert_equal expected_string, @compare.formatted
    end

    def test_formatted_returns_correct_string_for_no_change
      @current_next_dividend.amount = 150
      expected_string = 'Leave the dividend unchanged at $150.00.'
      assert_equal expected_string, @compare.formatted
    end
  end
end
