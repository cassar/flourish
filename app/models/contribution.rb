class Contribution < ApplicationRecord
  belongs_to :member

  validates :amount_in_base_units, numericality: { only_integer: true, greater_than: 0 }
  validates :fees_in_base_units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :transaction_identifier, uniqueness: true
  validates :currency, inclusion: {
    in: Paypal::SUPPORTED_CURRENCIES,
    message: :unsupported_currency
  }

  def amount_formatted
    Money.from_cents(amount_in_base_units).format
  end

  def fees_formatted
    Money.from_cents(fees_in_base_units).format
  end

  def gross_amount_formatted
    Money.from_cents(gross_amount_in_base_units).format
  end

  def created_at_formatted
    created_at.strftime("%a, #{created_at.day.ordinalize} %b %Y")
  end

  private

  def gross_amount_in_base_units
    amount_in_base_units + fees_in_base_units
  end
end
