# Preview all emails at http://localhost:3000/rails/mailers/admin_notification_mailer
class AdminNotificationMailerPreview < ActionMailer::Preview
  def pay_out_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    dividend = Dividend.new(id: 1, member:)
    AdminNotificationMailer.with(dividend:).pay_out_notification
  end
end
