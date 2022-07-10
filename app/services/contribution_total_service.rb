class ContributionTotalService
  class << self
    def call
      Money.from_amount(contribution_total).format
    end

    private

    def contribution_total
      Member.all.sum(:contribution_amount)
    end
  end
end
