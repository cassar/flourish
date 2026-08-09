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

  test 'generate and notify creates expenses and emails the admin' do
    ActionMailer::Base.deliveries.clear

    assert_difference 'Expense.count', WeeklyExpensesService::WEEKLY_EXPENSES.size do
      WeeklyExpensesService.generate_and_notify
    end

    assert_equal 1, ActionMailer::Base.deliveries.count
  end
end
