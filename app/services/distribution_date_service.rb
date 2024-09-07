class DistributionDateService
  DAY_OF_THE_WEEK = 'Friday'.freeze

  def self.next_date
    Date.parse(DAY_OF_THE_WEEK)
  end

  def self.today?
    Time.zone.today.eql? next_date
  end
end
