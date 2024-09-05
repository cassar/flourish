module Users
  class SessionsController < Devise::SessionsController
    invisible_captcha only: :create

    before_action :repel_bot!, only: :create
  end
end
