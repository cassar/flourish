class ContributionUuid < ActiveRecord::Migration[8.1]
  def change
    add_column :contributions, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
