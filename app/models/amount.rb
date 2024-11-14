class Amount < ApplicationRecord
  belongs_to :distribution
  has_many :dividends, dependent: :destroy

  include CurrencyValidator

  def amount_formatted
    Money.new(amount_in_base_units, currency).format
  end
end
