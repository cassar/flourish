# Preview all emails at http://localhost:3000/rails/mailers/dividend_pay_out_mailer
class DividendPayOutMailerPreview < ActionMailer::Preview
  def pay_out_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(payid: 'my_pay_id', user:)
    dividend = Dividend.new(id: 1, member:)
    DividendPayOutMailer.with(dividend:).pay_out_notification
  end
end
