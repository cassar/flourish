class PayOut < ApplicationRecord
  belongs_to :dividend

  validates :amount_in_base_units, numericality: { only_integer: true, greater_than: 0 }
  validates :fees_in_base_units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :transaction_identifier, uniqueness: true

  include CurrencyValidator

  def amount_formatted
    Money.new(amount_in_base_units, currency).format
  end

  def fees_formatted
    Money.new(fees_in_base_units, currency).format
  end
end
