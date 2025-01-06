class CreateNotificationPreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :notification_preferences do |t|
      t.references :member, null: false, foreign_key: true
      t.integer :notification_name, null: false
      t.boolean :enabled, default: true

      t.timestamps
    end

    add_index :notification_preferences, [:notification_name, :member_id], unique: true
  end
end
