class DistributionDateService
  DISTRIBUTION_DAY = 'Friday'.freeze

  def self.next_date
    Date.parse(DISTRIBUTION_DAY)
  end

  def self.today?
    Time.zone.today.eql? next_date
  end
end
