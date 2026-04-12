class CreateWebhookConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_configurations do |t|
      t.string :url

      t.timestamps
    end
  end
end
