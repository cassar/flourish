module NotificationPreferencesHelper
  def notification_emoji(enabled)
    if enabled
      '✅'
    else
      '⛔️'
    end
  end
end
