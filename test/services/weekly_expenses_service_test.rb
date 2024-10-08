require 'test_helper'

class WeeklyExpensesServiceTest < ActiveSupport::TestCase
  test 'Creates Expenses' do
    assert_difference 'Expense.count', WeeklyExpensesService::WEEKLY_EXPENSES.count do
      WeeklyExpensesService.call
    end
  end

  test 'sends notification to admin' do
    ActionMailer::Base.deliveries.clear

    WeeklyExpensesService.call

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert(ActionMailer::Base.deliveries.all? do |mail|
      mail.subject.match?(/New Expenses Added/)
    end)
  end
end
