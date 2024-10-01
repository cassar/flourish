namespace :services do
  desc 'creates a distribution and dividends and notifies members'
  task distribution: :environment do
    if DistributionDateService.today?
      members = Member.active
      DistributionService.new(
        members:,
        dividend_amount_in_base_units: DividendAmountService.new(
          total_pool_in_base_units: TotalPoolService.balance_in_base_units,
          member_count: members.count
        ).amount_in_base_units
      ).call
    end
  end

  desc 'recontributes unclaimed dividends and notifies member'
  task recontribution: :environment do
    if RecontributionDateService.today?
      mailgun_send_limit = 10
      RecontributionService.new(
        issued_dividends: Dividend.issued.take(mailgun_send_limit)
      ).call
    end
  end

  desc 'notifies users when a distribution has settled'
  task distribution_settled: :environment do
    if RecontributionDateService.today?
      DistributionSettledService.new(
        distribution: Distribution.last,
        users: User.joins(:member).where(member: Member.active)
      ).call
    end
  end
end
