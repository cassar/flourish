class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(_resource)
    pods_path
  end
end
