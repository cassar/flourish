module Users
  class RegistrationsController < Devise::RegistrationsController
    invisible_captcha only: :create
  end
end
