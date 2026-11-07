class DistributionService
  attr_reader :pod, :number, :members, :amounts
  attr_accessor :distribution, :dividends

  def initialize(pod:, number:, members:, amounts:)
    @pod = pod
    @number = number
    @members = members
    @amounts = amounts
  end

  def call
    create_distribution
    save_amounts
    create_dividends
    distribution
  end

  private

  def create_distribution
    @distribution = Distribution.create!(number:, pod:)
  end

  def save_amounts
    amounts.each do |amount|
      amount.distribution = distribution
      amount.save
    end
  end

  def create_dividends
    @dividends = MemberDividendService.new(members:, amounts:).call
  end
end
