class DistributionDayService
  DISTRIBUTION_DAY = 'Friday'.freeze

  def self.today?
    Time.zone.today.strftime('%A').eql? DISTRIBUTION_DAY
  end
end
