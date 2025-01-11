module Admin
  class PayOutsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    attr_accessor :pay_out, :dividend, :member

    after_action :wrap_up, only: :create, if: -> { pay_out.persisted? }

    def new
      @dividend = Dividend.find params[:dividend_id]
      @member = @dividend.member
      @amount = @dividend.amount
      @pay_out = @dividend.build_pay_out amount_in_base_units: @amount.amount_in_base_units
      @distribution = @amount.distribution
    end

    def preview
      @dividend = Dividend.find params[:dividend_id]
      @dividend.status = :pay_out_complete
      @pay_out = @dividend.build_pay_out(pay_out_params)
    end

    def create
      @dividend = Dividend.find params[:dividend_id]
      @member = @dividend.member
      @pay_out = @dividend.build_pay_out(pay_out_params)
      if @pay_out.save
        flash[:success] = I18n.t('controllers.admin.pay_outs.create.success')
        redirect_to admin_distributions_path
      else
        @amount = @dividend.amount
        @distribution = @amount.distribution
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

    def wrap_up
      dividend.pay_out_complete!
      return unless member.notification_preferences.dividend_paid_out.all?(&:enabled)

      NotificationMailer.with(pay_out:).dividend_paid_out.deliver_later
    end
  end
end
