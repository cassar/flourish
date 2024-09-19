class DistributionService
  attr_accessor :members, :dividend_amount_in_base_units

  def initialize(members:, dividend_amount_in_base_units:)
    @members = members
    @dividend_amount_in_base_units = dividend_amount_in_base_units
  end

  def call
    MemberDividendService.new(members:, distribution:).call
  end

  private

  def distribution
    Distribution.create! dividend_amount_in_base_units:
  end
end
