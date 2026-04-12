class ApplicationController < ActionController::Base
  private

  def current_currency
    return 'AUD' unless user_signed_in?

    current_user.member.currency
  end

  def log_page_view
    return unless user_signed_in?

    ActivityLog.create(message: yield)
  end
end
