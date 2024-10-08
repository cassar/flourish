class Expense < ApplicationRecord
  def amount_formatted
    Money.from_cents(amount_in_base_units).format
  end
end
