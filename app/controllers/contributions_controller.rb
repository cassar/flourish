class ContributionsController < ApplicationController
  def show
    @contribution = Contribution.find_by uuid: params[:uuid]
  end
end
