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
    Money.new(amount_in_base_units, orginal_currency).exchange_to(currency).amount
  end

  def currencies
    Currencies::SUPPORTED_CURRENCIES
  end
end
