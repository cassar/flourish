class UniquePaypalmeid < ActiveRecord::Migration[7.2]
  def change
    add_index :members, :paypalmeid, unique: true
  end
end
