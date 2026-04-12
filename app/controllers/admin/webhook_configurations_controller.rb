module Admin
  class WebhookConfigurationsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def show
      @webhook_configuration = WebhookConfiguration.instance
    end

    def update
      @webhook_configuration = WebhookConfiguration.instance
      if @webhook_configuration.update(webhook_configuration_params)
        flash[:success] = I18n.t('controllers.admin.webhook_configurations.update.success')
        redirect_to admin_webhook_configuration_path
      else
        flash.now[:alert] = @webhook_configuration.errors.full_messages.to_sentence
        render :show
      end
    end

    private

    def webhook_configuration_params
      params.expect(webhook_configuration: [:url])
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
