class PrepareEncryptPaypalmeHandle < ActiveRecord::Migration[8.1]
  def change
    add_column :members, :paypalme_handle_new, :string, limit: 1024
    add_index :members, :paypalme_handle_new, unique: true

    Member.find_each do |member|
      member.update! paypalme_handle_new: member.paypalme_handle
    end
  end
end
