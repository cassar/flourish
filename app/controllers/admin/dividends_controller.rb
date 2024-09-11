module Admin
  class DividendsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    attr_accessor :dividend

    def show
      @dividend = Dividend.find params[:id]
      @member = @dividend.member
    end

    def update
      @dividend = Dividend.find params[:id]
      @dividend.update!(dividend_params)
      NotificationMailer.with(dividend:).dividend_paid_out.deliver_later
      @member = @dividend.member
      flash.now[:success] = I18n.t('controllers.admin.dividends.update.success')
      render :show
    end

    private

    def dividend_params
      params.require(:dividend).permit(:receipt)
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to dividends_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
