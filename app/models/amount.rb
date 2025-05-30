class Amount < ApplicationRecord
  belongs_to :distribution
  has_many :dividends, dependent: :destroy

  include CurrencyValidator

  def amount_formatted
    money.format
  end

  def amount_formatted_without_currency
    money.format(with_currency: false)
  end

  def currency_name
    money.currency.name
  end

  private

  def money
    Money.new(amount_in_base_units, currency)
  end
end
