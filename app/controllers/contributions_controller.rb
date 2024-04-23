class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @member = current_user.member
    @contributions = @member.contributions.order(created_at: :desc)
  end
end
