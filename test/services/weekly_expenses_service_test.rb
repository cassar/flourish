require 'test_helper'

class WeeklyExpensesServiceTest < ActiveSupport::TestCase
  test 'last weeks expenses' do
    assert WeeklyExpensesService.last_weeks_expenses
  end

  test 'last weeks expenses total' do
    assert_instance_of Integer, WeeklyExpensesService.last_weeks_expenses_total
  end

  test 'last weeks expensese total formatted' do
    assert_instance_of String, WeeklyExpensesService.last_weeks_expeneses_total_formatted
  end
end
