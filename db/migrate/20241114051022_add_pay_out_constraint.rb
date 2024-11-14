class AddPayOutConstraint < ActiveRecord::Migration[8.1]
  def change
    add_index :pay_outs, :transaction_identifier, unique: true
    change_column_null :pay_outs, :transaction_identifier, false
  end
end
