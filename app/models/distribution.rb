class Distribution < ApplicationRecord
  has_many :dividends, dependent: :destroy
  has_many :amounts, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  def dividend_amount_formatted
    Money.from_cents(dividend_amount_in_base_units).format
  end
end
