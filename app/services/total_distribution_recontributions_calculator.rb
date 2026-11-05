class TotalDistributionRecontributionsCalculator
  attr_reader :distribution

  def initialize(distribution)
    @distribution = distribution
  end

  def formatted(currency)
    CurrencyConverter.format_from_aud(amount_in_base_units, currency)
  end

  private

  def amount_in_base_units
    CurrencyConverter.in_aud_base_units total_recontributions_by_currency
  end

  def total_recontributions_by_currency
    TotalPodCalculations.recontributions_by_currency(distribution)
  end
end
