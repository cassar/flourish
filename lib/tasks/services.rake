namespace :services do
  desc 'creates a distribution and dividends and notifies members'
  task distribution: :environment do
    NextDistributionService.distribute! if NextDistributionService.today?
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
        users: User.active
      ).call
    end
  end
end
