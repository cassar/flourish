module DividendService
  class NextDividendAmountCompare
    attr_reader :current_next_dividend, :future_next_dividend

    def initialize(current_next_dividend:, future_next_dividend:)
      @current_next_dividend = current_next_dividend
      @future_next_dividend = future_next_dividend
    end

    def formatted
      I18n.t("services.dividend_service.next_dividend_compare.#{direction_of_amount_change_string}",
             amount_difference: difference_in_dividend_amounts_formatted,
             future_amount: future_next_dividend.amount_formatted)
    end

    private

    def direction_of_amount_change_string
      if increase_in_dividend?
        'increase'
      elsif decrease_in_dividend?
        'decrease'
      else
        'no_change'
      end
    end

    def increase_in_dividend?
      current_next_dividend.amount < future_next_dividend.amount
    end

    def decrease_in_dividend?
      future_next_dividend.amount < current_next_dividend.amount
    end

    def difference_in_dividend_amounts_formatted
      Money.from_amount(absolute_difference_in_dividend_amounts).format
    end

    def absolute_difference_in_dividend_amounts
      difference_in_dividend_amounts.abs
    end

    def difference_in_dividend_amounts
      future_next_dividend.amount - current_next_dividend.amount
    end
  end
end
