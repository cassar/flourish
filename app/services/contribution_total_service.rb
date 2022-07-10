class ContributionTotalService
  def self.call
    Member.all.sum(:contribution_amount)
  end
end
