class ContributionsController < ApplicationController
  def show
    @contribution = Contribution.find_by uuid: params[:uuid]
    log_page_view { "#{current_user.email} viewed a contribution" }
  end
end
