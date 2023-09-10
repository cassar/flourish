class TotalContributionsService
  class << self
    def amount
      Member.sum(:contribution_amount)
    end

    def formatted
      Money.from_amount(amount).format
    end
  end
end
