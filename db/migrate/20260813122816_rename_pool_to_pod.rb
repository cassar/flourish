class RenamePoolToPod < ActiveRecord::Migration[8.2]
  def change
    rename_table :pools, :pods
    rename_table :pool_memberships, :pod_memberships

    rename_column :pod_memberships, :pool_id, :pod_id
    rename_column :contributions, :pool_id, :pod_id
    rename_column :distributions, :pool_id, :pod_id

    rename_index :pod_memberships, 'index_pool_memberships_on_pool_id_and_member_id',
                 'index_pod_memberships_on_pod_id_and_member_id'
    rename_index :pod_memberships, 'index_pool_memberships_on_pool_id',
                 'index_pod_memberships_on_pod_id'
    rename_index :pod_memberships, 'index_pool_memberships_on_pool_id_one_contributor',
                 'index_pod_memberships_on_pod_id_one_contributor'
    rename_index :pod_memberships, 'index_pool_memberships_on_member_id',
                 'index_pod_memberships_on_member_id'

    rename_index :contributions, 'index_contributions_on_pool_id', 'index_contributions_on_pod_id'
    rename_index :distributions, 'index_distributions_on_pool_id', 'index_distributions_on_pod_id'
    rename_index :distributions, 'index_distributions_on_pool_id_and_number',
                 'index_distributions_on_pod_id_and_number'
  end
end
