class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def show
    @member = current_user.member
    log_page_view "#{current_user.email} viewed their membership"
  end
end
