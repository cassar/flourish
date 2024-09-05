module Users
  class RegistrationsController < Devise::RegistrationsController
    invisible_captcha only: :create

    before_action :repel_bot!, only: :create
  end
end
