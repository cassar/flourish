class CurrencyConverter
  class << self
    def in_aud_base_units(amount_in_base_units_by_currency)
      amount_in_base_units_by_currency.sum do |currency, amount_in_base_units|
        new(
          from_currency: currency,
          amount_in_base_units:,
          to_currency: 'AUD'
        ).amount_in_base_units
      end
    end

    def format_from_aud(amount_in_base_units, to_currency)
      new(
        from_currency: 'AUD',
        amount_in_base_units:,
        to_currency:
      ).format
    end
  end

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
