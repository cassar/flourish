module Admin
  class PayOutsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    attr_accessor :pay_out

    def edit
      @pay_out = PayOut.find params[:id]
      @dividend = @pay_out.dividend
      @member = @dividend.member
      @amount = @dividend.amount
      @distribution = @amount.distribution
    end

    def update
      @pay_out = PayOut.find params[:id]
      @pay_out.update!(pay_out_params)
      NotificationMailer.with(pay_out:).dividend_paid_out.deliver_later
      flash[:success] = I18n.t('controllers.admin.dividends.update.success')
      redirect_to edit_admin_pay_out_path(@pay_out)
    end

    private

    def pay_out_params
      params.require(:pay_out).permit(:transaction_identifier)
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
