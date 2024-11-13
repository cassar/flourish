class DistributionService
  attr_accessor :members, :amount_in_base_units, :name

  def initialize(members:, amount_in_base_units:, name:)
    @members = members
    @amount_in_base_units = amount_in_base_units
    @name = name
  end

  def call
    MemberDividendService.new(members:, amount:).call
  end

  private

  def amount
    distribution = Distribution.create!(name:)
    distribution.amounts.create! amount_in_base_units:
  end
end
