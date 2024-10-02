class NextDistributionNameService
  def self.call
    "##{Distribution.count + 1}"
  end
end
