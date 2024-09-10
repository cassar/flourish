class DistributionsController < ApplicationController
  def index
    @distributions = Distribution.order(created_at: :desc).preload(:dividends)
  end
end
