class NextDistributionNumberService
  def self.call(pot)
    pot.distributions.maximum(:number).to_i + 1
  end
end
