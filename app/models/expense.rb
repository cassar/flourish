class Expense < ApplicationRecord
  belongs_to :distribution, optional: true

  def amount_formatted
    Money.new(amount_in_base_units, 'AUD').format
  end
end
