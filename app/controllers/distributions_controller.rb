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
    totals
  end

  def totals
    @total_expenses_formatted = CurrencyConverter.new(
      from_currency: Currencies::DEFAULT,
      amount_in_base_units: @expenses.sum(:amount_in_base_units),
      to_currency: current_currency
    ).format
    @total_recontributions_formatted = TotalDistributionRecontributionsCalculator
      .new(@previous_distribution)
      .formatted(current_currency)
  end
end
