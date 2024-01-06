class Distribution < ApplicationRecord
  has_many :dividends, dependent: :destroy

  def dividend_amount_formatted
    Money.from_amount(dividend_amount).format
  end
end
