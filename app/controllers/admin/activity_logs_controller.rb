module Admin
  class ActivityLogsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def index
      @activity_logs = ActivityLog.order(created_at: :desc).limit(100)
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
