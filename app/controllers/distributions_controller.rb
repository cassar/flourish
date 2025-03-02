class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.order(created_at: :desc).preload(amounts: :dividends)
  end

  def show
    @distribution = Distribution.find_by number: params[:id]
  end
end
