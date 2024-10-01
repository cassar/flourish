class DistributionSettledService
  class DistributionNotSettledError < StandardError; end

  attr_accessor :users, :distribution

  def initialize(users:, distribution:)
    @users = users
    @distribution = distribution
  end

  def call
    raise DistributionNotSettledError if @distribution.dividends.issued.any?

    users.each do |user|
      NotificationMailer.with(distribution:, user:).distribution_settled.deliver_now
    end
  end
end
