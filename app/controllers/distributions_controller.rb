class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.order(created_at: :desc).preload(amounts: :dividends)
  end
end
