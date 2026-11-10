class RenamePodToPot < ActiveRecord::Migration[8.2]
  def change
    rename_table :pods, :pots
    rename_table :pod_memberships, :pot_memberships

    rename_column :pot_memberships, :pod_id, :pot_id
    rename_column :contributions, :pod_id, :pot_id
    rename_column :distributions, :pod_id, :pot_id

    rename_index :pot_memberships, 'index_pod_memberships_on_pod_id_and_member_id',
                 'index_pot_memberships_on_pot_id_and_member_id'
    rename_index :pot_memberships, 'index_pod_memberships_on_pod_id',
                 'index_pot_memberships_on_pot_id'
    rename_index :pot_memberships, 'index_pod_memberships_on_pod_id_one_contributor',
                 'index_pot_memberships_on_pot_id_one_contributor'
    rename_index :pot_memberships, 'index_pod_memberships_on_member_id',
                 'index_pot_memberships_on_member_id'

    rename_index :contributions, 'index_contributions_on_pod_id', 'index_contributions_on_pot_id'
    rename_index :distributions, 'index_distributions_on_pod_id', 'index_distributions_on_pot_id'
    rename_index :distributions, 'index_distributions_on_pod_id_and_number',
                 'index_distributions_on_pot_id_and_number'
  end
end
