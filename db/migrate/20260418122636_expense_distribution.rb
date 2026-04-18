class ExpenseDistribution < ActiveRecord::Migration[8.2]
  def change
    add_reference :expenses, :distribution, foreign_key: true

    Distribution.order(:number).each do |distribution|
      previous_distribution = Distribution.find_by(number: distribution.number - 1) || Distribution.new
      Expense.where(created_at: previous_distribution.created_at..distribution.created_at).each do |expense|
        expense.update! distribution_id: distribution.id
      end
    end
  end
end
