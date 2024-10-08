# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminNotificationMailerPreview < ActionMailer::Preview
  def pay_out_requested
    user = User.new(email: 'email@example.com')
    member = Member.new(user:)
    dividend = Dividend.new(id: 1, member:)
    AdminNotificationMailer.with(dividend:).pay_out_requested
  end

  def expenses_added
    expenses = [
      Expense.new(amount_in_base_units: 384, name: 'Service 1'),
      Expense.new(amount_in_base_units: 398, name: 'Service 2')
    ]
    AdminNotificationMailer.with(expenses:).expenses_added
  end
end
