class PayOut < ApplicationRecord
  belongs_to :dividend

  validates :transaction_identifier, uniqueness: true

  include CurrencyValidator

  def amount_formatted
    Money.new(amount_in_base_units, currency).format
  end

  def fees_formatted
    Money.new(fees_in_base_units, currency).format
  end
end
