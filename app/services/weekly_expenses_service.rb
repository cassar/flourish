class WeeklyExpensesService
  WEEKLY_EXPENSES = [
    {
      name: 'Hosting and Infrastructure',
      amount_in_base_units: 889
    },
    {
      name: 'Domain Registration',
      amount_in_base_units: 116
    }
  ].freeze

  class << self
    def generate_and_notify
      expenses = WEEKLY_EXPENSES.map do |expense|
        Expense.create!(expense)
      end

      AdminNotificationMailer.with(expenses:).expenses_added.deliver_now
    end

    def last_weeks_expenses
      Expense.where(created_at: 1.week.ago..Time.current)
    end

    def last_weeks_expenses_total
      last_weeks_expenses.sum(:amount_in_base_units)
    end

    def last_weeks_expeneses_total_formatted
      Money.new(last_weeks_expenses_total, 'AUD').format
    end
  end
end
