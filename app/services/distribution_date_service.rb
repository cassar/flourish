class DistributionDateService
  DAY_OF_THE_WEEK = 'Friday'.freeze

  class << self
    def next_date
      Date.parse(DAY_OF_THE_WEEK)
    end

    def today?
      Time.zone.today.eql? next_date
    end
  end
end
