class CreatePoolMemberships < ActiveRecord::Migration[8.2]
  def change
    create_table :pool_memberships do |t|
      t.references :pool, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.integer :role, null: false, default: 1

      t.timestamps
    end

    add_index :pool_memberships, %i[pool_id member_id], unique: true
    add_index :pool_memberships, :pool_id, unique: true, where: "role = 0",
      name: "index_pool_memberships_on_pool_id_one_contributor"
  end
end
