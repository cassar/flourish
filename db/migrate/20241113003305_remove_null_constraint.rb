class RemoveNullConstraint < ActiveRecord::Migration[8.1]
  def change
    change_column_null :pay_outs, :transaction_identifier, true
  end
end
