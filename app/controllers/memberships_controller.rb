class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def show
    @member = current_user.member
  end
end
