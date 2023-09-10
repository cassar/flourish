module DividendService
  class Distribution
    attr_reader :member_count, :available_funds, :minimum_dividend

    def initialize(member_count:, available_funds:, minimum_dividend:)
      @member_count = member_count
      @available_funds = available_funds
      @minimum_dividend = minimum_dividend
    end

    def dividend_to_pay?
      dividend >= minimum_dividend
    end

    def dividend
      available_funds / member_count
    rescue ZeroDivisionError
      0
    end
  end
end
