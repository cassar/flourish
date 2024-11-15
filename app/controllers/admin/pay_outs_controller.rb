module Admin
  class PayOutsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    attr_accessor :pay_out

    after_action :notify_member, only: :create

    def new
      @dividend = Dividend.find params[:dividend_id]
      @pay_out = @dividend.build_pay_out
      @member = @dividend.member
      @amount = @dividend.amount
      @distribution = @amount.distribution
    end

    def preview
      @dividend = Dividend.find params[:dividend_id]
      @dividend.status = :pay_out_complete
      @pay_out = @dividend.build_pay_out(pay_out_params)
    end

    def create
      new
      @pay_out = @dividend.build_pay_out(pay_out_params)
      if @pay_out.save
        flash[:success] = I18n.t('controllers.admin.pay_outs.create.success')
        redirect_to admin_distributions_path
      else
        flash.now[:error] = @pay_out.errors.full_messages.to_sentence
        render :new
      end
    end

    private

    def pay_out_params
      params.require(:pay_out).permit(:currency, :amount_in_base_units, :fees_in_base_units, :transaction_identifier)
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path, alert: I18n.t('controllers.admin.not_authorised')
    end

    def notify_member
      return unless @pay_out.persisted?

      NotificationMailer.with(pay_out:).dividend_paid_out.deliver_later
    end
  end
end
