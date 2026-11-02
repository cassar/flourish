class TotalDistributionRecontributionsCalculator
  attr_reader :distribution

  def initialize(distribution)
    @distribution = distribution
  end

  def formatted(currency)
    CurrencyConverter.new(
      from_currency: 'AUD',
      amount_in_base_units:,
      to_currency: currency
    ).format
  end

  private

  def amount_in_base_units
    CurrencyConverter.in_aud_base_units total_recontributions_by_currency
  end

  def total_recontributions_by_currency
    TotalPodCalculations.recontributions_by_currency(distribution)
  end
end
