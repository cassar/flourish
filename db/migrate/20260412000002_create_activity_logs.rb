class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.text :message, null: false

      t.timestamps
    end
  end
end
