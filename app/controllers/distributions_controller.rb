class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.order(created_at: :desc).preload(amounts: :dividends)
  end

  def show
    @distribution = Distribution.find_by number: params[:id]
    @previous_distribution = Distribution.find_by(number: @distribution.number - 1) || Distribution.new
    summary_information
  end

  private

  def summary_information
    @contributions = Contribution.where(created_at: @previous_distribution.created_at..@distribution.created_at)
    @expenses = Expense.where(created_at: @previous_distribution.created_at..@distribution.created_at)
    @amounts = @distribution.amounts
    @total_recontributions_formatted = TotalDistributionRecontributionsCalculator
      .new(@previous_distribution)
      .formatted(current_currency)
  end
end
