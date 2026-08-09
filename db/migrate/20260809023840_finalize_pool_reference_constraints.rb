class FinalizePoolReferenceConstraints < ActiveRecord::Migration[8.2]
  def up
    unassigned_distributions = Distribution.where(pool_id: nil).count
    unassigned_contributions = Contribution.where(pool_id: nil).count
    if unassigned_distributions.positive? || unassigned_contributions.positive?
      raise "Cannot finalize: #{unassigned_distributions} distributions and " \
        "#{unassigned_contributions} contributions have no pool_id. " \
        'Run BackfillPoolsFromHistoricalData first, or resolve orphaned rows manually.'
    end

    change_column_null :distributions, :pool_id, false
    change_column_null :contributions, :pool_id, false

    remove_index :distributions, :number, name: 'index_distributions_on_number'
    add_index :distributions, %i[pool_id number], unique: true
  end

  def down
    remove_index :distributions, %i[pool_id number]
    add_index :distributions, :number, unique: true, name: 'index_distributions_on_number'

    change_column_null :distributions, :pool_id, true
    change_column_null :contributions, :pool_id, true
  end
end
