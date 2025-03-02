class AddDistributionNumber < ActiveRecord::Migration[8.1]
  def change
    add_column :distributions, :number, :integer

    Distribution.all.each do |distribution|
      distribution.update! number: distribution.name.remove('#').to_i
    end
  end
end
