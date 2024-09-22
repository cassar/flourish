module Admin
  class MembersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def active
      @members = Member.active.preload(:user)
      @total_member_count = @members.count
      render :index
    end

    def inactive
      @members = Member.where.not(id: Member.active).preload(:user)
      @total_member_count = @members.count
      render :index
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path
    end
  end
end
