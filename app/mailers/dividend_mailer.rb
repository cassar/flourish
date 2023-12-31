class DividendMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def pay_out_notification
    @dividend = params[:dividend]
    @member = @dividend.member
    @user = @member.user
    mail(to: User::ADMIN_EMAIL, subject: "#{@user.email} has requested a Pay Out")
  end
end
