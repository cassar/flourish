class ContributionDistribution < ActiveRecord::Migration[8.1]
  def change
    add_reference :contributions, :distribution

    Distribution.all.each do |distribution|
      previous_distribution = Distribution.find_by(number: distribution.number - 1) || Distribution.new
      contributions = Contribution.where(created_at: previous_distribution.created_at..distribution.created_at)
      contributions.each do |contribution|
        contribution.update! distribution_id: distribution.id
      end
    end

    add_foreign_key :contributions, :distributions, null: false
    change_column_null :contributions, :distribution_id, false
  end
end
