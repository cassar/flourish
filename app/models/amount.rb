class Amount < ApplicationRecord
  belongs_to :distribution
  has_many :dividends, dependent: :destroy

  def amount_formatted
    Money.from_cents(amount_in_base_units).format
  end
end
