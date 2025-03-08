class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.order(created_at: :desc).preload(amounts: :dividends)
  end

  def show
    @distribution = Distribution.find_by number: params[:id]
    previous_distribution = Distribution.find_by(number: @distribution.number - 1) || Distribution.new
    @contributions = Contribution.where(created_at: previous_distribution.created_at..@distribution.created_at)
  end
end
