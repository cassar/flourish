class AddMemberCurrency < ActiveRecord::Migration[8.1]
  def change
    add_column :members, :currency, :string, default: 'AUD'
  end
end
