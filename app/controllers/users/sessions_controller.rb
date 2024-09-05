class Users::SessionsController < Devise::SessionsController
  invisible_captcha only: [:create]
end
