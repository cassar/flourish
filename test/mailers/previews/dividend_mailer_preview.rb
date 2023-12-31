# Preview all emails at http://localhost:3000/rails/mailers/dividend_mailer
class DividendMailerPreview < ActionMailer::Preview
  def pay_out_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(payid: 'my_pay_id', user:)
    dividend = Dividend.new(id: 1, member:)
    DividendMailer.with(dividend:).pay_out_notification
  end
end
