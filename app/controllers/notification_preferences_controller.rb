class NotificationPreferencesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @member = current_user.member
    @notification_preferences = @member.notification_preferences.order(:notification_name)
  end

  def update
    @member = current_user.member
    if @member.update(member_params)
      flash[:success] = I18n.t('controllers.notification_preferences.update.success')
      redirect_to edit_user_registration_path
    else
      @notification_preferences = @member.notification_preferences.order(:notification_name)
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(notification_preferences_attributes: %i[id enabled])
  end
end
