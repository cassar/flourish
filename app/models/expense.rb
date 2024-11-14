class Expense < ApplicationRecord
  def amount_formatted
    Money.new(amount_in_base_units, 'AUD').format
  end
end
