class RemoveAutoRecontributedNotificationPreferences < ActiveRecord::Migration[8.2]
  # The "dividend automatically recontributed" notification no longer exists.
  DIVIDEND_AUTOMATICALLY_RECONTRIBUTED = 3

  def up
    execute "DELETE FROM notification_preferences WHERE notification_name = #{DIVIDEND_AUTOMATICALLY_RECONTRIBUTED}"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
