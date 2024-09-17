class ApplicationController < ActionController::Base
  private

  def repel_bot_with_invisible_captcha
    Honeybadger.notify("A bot was repeled with invisible_captcha")
    head :ok
  end

  def repel_bot_with_voight_kampff
    return unless request.bot?

    Honeybadger.notify("A bot was repeled with voight_kampff")
    head :ok
  end
end
