module Users
  class SessionsController < Devise::SessionsController
    invisible_captcha only: [:create]
  end
end
