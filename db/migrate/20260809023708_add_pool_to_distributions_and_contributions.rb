class AddPoolToDistributionsAndContributions < ActiveRecord::Migration[8.2]
  def change
    add_reference :distributions, :pool, foreign_key: true
    add_reference :contributions, :pool, foreign_key: true
  end
end
