require 'test_helper'

class WeeklyExpensesServiceTest < ActiveSupport::TestCase
  test 'generate and notify creates expenses' do
    assert_difference 'Expense.count', WeeklyExpensesService::WEEKLY_EXPENSES.count do
      WeeklyExpensesService.generate_and_notify
    end
  end

  test 'generate and notify sends notification to admin' do
    ActionMailer::Base.deliveries.clear

    WeeklyExpensesService.generate_and_notify

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/New Expenses Added/)
    end)
  end

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
