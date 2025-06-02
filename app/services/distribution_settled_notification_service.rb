class DistributionSettledNotificationService
  class DistributionNotSettledError < StandardError; end

  attr_accessor :users, :distribution

  def initialize(users:, distribution:)
    @users = users
    @distribution = distribution
  end

  def call
    raise DistributionNotSettledError unless distribution.settled?

    send_email_notifications
    post_to_bluesky
    post_to_mastodon
  end

  private

  def send_email_notifications
    users.each do |user|
      NotificationMailer.with(distribution:, user:).distribution_settled.deliver_now
    end
  end

  def post_to_bluesky
    BlueskyDistributionSettled.new(distribution:).call
  end

  def post_to_mastodon
    MastodonDistributionSettled.new(distribution:).call
  end
end
