class RemoveDistributionForeign < ActiveRecord::Migration[8.1]
  def change
    change_column_null :contributions, :distribution_id, true
  end
end
