module DividendService
  class NextDividendDateCompare
    include ActionView::Helpers::DateHelper

    attr_reader :current_next_dividend, :future_next_dividend

    def initialize(current_next_dividend:, future_next_dividend:)
      @current_next_dividend = current_next_dividend
      @future_next_dividend = future_next_dividend
    end

    def formatted
      return if [future_next_dividend.date, current_next_dividend.date].any?(nil)

      I18n.t("services.dividend_service.next_dividend_compare.#{direction_of_time_change_label}",
             time_amount: difference_in_dividend_dates,
             dividend_date: future_next_dividend.date_formatted)
    end

    private

    def direction_of_time_change_label
      if next_dividend_date_brought_forward?
        'bring_forward'
      elsif next_dividend_date_pushed_back?
        'push_back'
      elsif current_next_dividend.date == future_next_dividend.date
        'unchanged'
      end
    end

    def next_dividend_date_brought_forward?
      future_next_dividend.date < current_next_dividend.date
    end

    def next_dividend_date_pushed_back?
      current_next_dividend.date < future_next_dividend.date
    end

    def difference_in_dividend_dates
      distance_of_time_in_words(future_next_dividend.date, current_next_dividend.date)
    end
  end
end
