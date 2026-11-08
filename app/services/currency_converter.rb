class CurrencyConverter
  attr_reader :from_currency, :from_amount_in_base_units, :to_currency

  def initialize(from_currency:, amount_in_base_units:, to_currency:)
    @from_currency = from_currency
    @from_amount_in_base_units = amount_in_base_units
    @to_currency = to_currency
    check_currencies
  end

  def amount_in_base_units
    conversion.fractional
  end

  delegate :format, to: :conversion

  private

  def conversion
    Money.new(from_amount_in_base_units, from_currency).exchange_to(to_currency)
  end

  def check_currencies
    conversion
  rescue Money::Bank::UnknownRate
    CurrencyUpdaterService.call
  end
end
