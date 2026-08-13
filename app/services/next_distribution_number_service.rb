class NextDistributionNumberService
  def self.call(pod)
    pod.distributions.maximum(:number).to_i + 1
  end
end
