module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def index
      @users = User.order(last_sign_in_at: :desc)
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path
    end
  end
end
