module Admin
  class DividendsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_user!

    def show
      @dividend = Dividend.find params[:id]
    end

    def update
      @dividend = Dividend.find params[:id]
      @dividend.update(dividend_params)
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
