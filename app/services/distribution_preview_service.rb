class DistributionPreviewService
  attr_accessor :users

  def initialize(users:)
    @users = users
  end

  def call
    users.each do |user|
      NotificationMailer.with(user:).distribution_preview.deliver_now
    end
  end
end
