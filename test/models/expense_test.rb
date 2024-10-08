require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  test 'amount_formatted' do
    assert_equal '$9.98 AUD', Expense.new(amount_in_base_units: 998).amount_formatted
  end
end
