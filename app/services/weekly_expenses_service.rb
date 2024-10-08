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

  def self.call
    expenses = WEEKLY_EXPENSES.map do |expense|
      Expense.create!(expense)
    end

    AdminNotificationMailer.with(expenses:).expenses_added.deliver_now
  end
end
