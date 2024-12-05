class DividendAmountsService
  attr_reader :amount_in_base_units, :orginal_currency

  def initialize(amount_in_base_units:, currency:)
    @amount_in_base_units = amount_in_base_units
    @orginal_currency = currency
  end

  def call
    currencies.map do |currency|
      Amount.new currency:, amount_in_base_units: amount_from(currency)
    end
  end

  private

  def amount_from(currency)
    CurrencyConverter.new(
      from_currency: orginal_currency,
      amount_in_base_units:,
      to_currency: currency
    ).amount_in_base_units
  end

  def currencies
    Currencies::SUPPORTED_CURRENCIES
  end
end
