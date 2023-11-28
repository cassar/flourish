class Distribution < ApplicationRecord
  def dividend_amount_formatted
    Money.from_amount(dividend_amount).format
  end
end
