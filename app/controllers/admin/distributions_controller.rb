module Admin
  class DistributionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def index
      @distributions = Distribution.order(created_at: :desc).preload(:dividends)
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path
    end
  end
end
