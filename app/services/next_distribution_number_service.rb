class NextDistributionNumberService
  def self.call(pool)
    pool.distributions.maximum(:number).to_i + 1
  end
end
