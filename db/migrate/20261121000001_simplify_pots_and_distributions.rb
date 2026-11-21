class SimplifyPotsAndDistributions < ActiveRecord::Migration[8.2]
  def up
    # Everyone in a pot is just a member: no contributor/recipient roles.
    remove_index :pot_memberships, name: 'index_pot_memberships_on_pot_id_one_contributor'
    remove_column :pot_memberships, :role

    # A distribution pays out exactly one contribution. The pots backfill gave
    # every historical contribution its own distribution (found through its
    # "legacy-contribution-<id>" pay out) but left the contribution pointing at
    # the old shared distribution it was pooled into; point it at its own.
    execute <<~SQL
      UPDATE contributions SET distribution_id = (
        SELECT amounts.distribution_id FROM pay_outs
        JOIN dividends ON dividends.id = pay_outs.dividend_id
        JOIN amounts ON amounts.id = dividends.amount_id
        WHERE pay_outs.transaction_identifier = 'legacy-contribution-' || contributions.id
      )
      WHERE EXISTS (
        SELECT 1 FROM pay_outs WHERE pay_outs.transaction_identifier = 'legacy-contribution-' || contributions.id
      )
    SQL

    duplicates = select_values(<<~SQL)
      SELECT distribution_id FROM contributions
      WHERE distribution_id IS NOT NULL
      GROUP BY distribution_id HAVING COUNT(*) > 1
    SQL
    if duplicates.any?
      raise "Distributions #{duplicates.join(', ')} have more than one contribution; " \
            'resolve them before adding the unique index'
    end

    remove_index :contributions, :distribution_id
    add_index :contributions, :distribution_id, unique: true
  end

  def down
    remove_index :contributions, :distribution_id
    add_index :contributions, :distribution_id

    add_column :pot_memberships, :role, :integer, default: 1, null: false
    add_index :pot_memberships, :pot_id, unique: true, where: 'role = 0',
                                         name: 'index_pot_memberships_on_pot_id_one_contributor'
  end
end
