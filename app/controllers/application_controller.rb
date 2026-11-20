class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(_resource)
    pots_path
  end

  def current_member
    current_user.member
  end
end
