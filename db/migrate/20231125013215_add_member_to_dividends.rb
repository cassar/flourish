class AddMemberToDividends < ActiveRecord::Migration[7.1]
  def change
    add_reference :dividends, :member, foreign_key: true
  end
end
