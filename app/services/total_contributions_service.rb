class TotalContributionsService
  class << self
    def amount
      Member.all.sum(:contribution_amount)
    end

    def formatted
      Money.from_amount(amount).format
    end
  end
end
