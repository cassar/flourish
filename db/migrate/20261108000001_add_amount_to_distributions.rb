class AddAmountToDistributions < ActiveRecord::Migration[8.2]
  def change
    # Total paid out for the distribution, in AUD base units (cents).
    add_column :distributions, :amount_in_base_units, :integer, null: false, default: 0
  end
end
