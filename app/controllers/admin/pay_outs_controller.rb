module Admin
  class PayOutsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    attr_accessor :dividend

    def edit
      @dividend = Dividend.find params[:id]
      @member = @dividend.member
      @distribution = @dividend.distribution
    end

    def update
      @dividend = Dividend.find params[:id]
      @dividend.update!(dividend_params)
      NotificationMailer.with(dividend:).dividend_paid_out.deliver_later
      @member = @dividend.member
      @distribution = @dividend.distribution
      flash.now[:success] = I18n.t('controllers.admin.dividends.update.success')
      render :edit
    end

    private

    def dividend_params
      params.require(:dividend).permit(:transaction_identifier)
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to dividends_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
