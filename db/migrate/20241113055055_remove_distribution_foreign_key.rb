class RemoveDistributionForeignKey < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :dividends, :distributions
    change_column_null :dividends, :distribution_id, true
  end
end
