module Admin
  class DividendsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_user!

    attr_accessor :dividend

    def show
      @dividend = Dividend.find params[:id]
      @member = @dividend.member
    end

    def update
      @dividend = Dividend.find params[:id]
      @dividend.update!(dividend_params)
      DividendMailer.with(dividend:).paid_out_notification.deliver_later
      @member = @dividend.member
      flash.now[:success] = I18n.t('controllers.admin.dividends.update.success')
      render :show
    end

    private

    def dividend_params
      params.require(:dividend).permit(:receipt)
    end

    def authorise_user!
      return if current_user.admin?

      redirect_to dividends_path, alert: I18n.t('controllers.admin.dividends.not_authorised')
    end
  end
end
