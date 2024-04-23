class Contribution < ApplicationRecord
  belongs_to :member

  validates :up_bank_transaction_reference, uniqueness: true
  validates :amount_in_base_units, numericality: { only_integer: true, greater_than: 0 }

  def amount_formatted
    Money.from_cents(amount_in_base_units).format
  end
end
