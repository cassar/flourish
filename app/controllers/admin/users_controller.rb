module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def destroy
      user = User.find params[:id]
      user.destroy!
      flash[:success] = "User '#{user.email}' Destroyed"
      redirect_to inactive_admin_members_path
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path
    end
  end
end
