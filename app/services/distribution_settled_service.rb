class DistributionSettledService
  class DistributionNotSettledError < StandardError; end

  attr_accessor :users, :distribution

  def initialize(users:, distribution:)
    @users = users
    @distribution = distribution
  end

  def call
    raise DistributionNotSettledError unless distribution.settled?

    users.each do |user|
      NotificationMailer.with(distribution:, user:).distribution_settled.deliver_now
    end
  end
end
