class WebhookPosterJob < ApplicationJob
  queue_as :default

  def perform(message)
    WebhookPoster.new(message).call
  end
end
