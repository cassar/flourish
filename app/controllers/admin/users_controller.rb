module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    def index
      @users = User.order(Arel.sql('confirmed_at NULLS LAST'), Arel.sql('last_sign_in_at DESC NULLS LAST'))
      @total_user_count = User.count
    end

    private

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path
    end
  end
end
