class ActivityLog < ApplicationRecord
  validates :message, presence: true

  after_create_commit :post_to_webhook

  private

  def post_to_webhook
    WebhookPosterJob.perform_later(message)
  end
end
