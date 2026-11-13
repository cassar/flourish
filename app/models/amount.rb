class Amount < ApplicationRecord
  belongs_to :distribution
  has_many :dividends, dependent: :destroy

  has_one :pot, through: :distribution

  include CurrencyValidator

  def amount_formatted
    money.format
  end

  private

  def money
    Money.new(amount_in_base_units, currency)
  end
end
