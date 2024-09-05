class ApplicationController < ActionController::Base
  private

  def repel_bot!
    return unless request.bot?

    head :ok
  end
end
