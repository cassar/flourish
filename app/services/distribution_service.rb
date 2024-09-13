class DistributionService
  class NotTodayError < StandardError; end

  attr_accessor :run_today, :members, :dividend_amount_in_base_units

  def initialize(run_today:, members:, dividend_amount_in_base_units:)
    @run_today = run_today
    @members = members
    @dividend_amount_in_base_units = dividend_amount_in_base_units
  end

  def call
    raise NotTodayError unless run_today

    MemberDividendService.new(members:, distribution:).call
  end

  private

  def distribution
    Distribution.create! dividend_amount_in_base_units:
  end
end
