class ContributionFees < ActiveRecord::Migration[7.2]
  def change
    add_column :contributions, :fees_in_base_units, :integer, default: 0
    add_column :contributions, :transaction_identifier, :string
    add_index :contributions, :transaction_identifier, unique: true
  end
end
