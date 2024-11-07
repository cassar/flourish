namespace :services do
  desc 'creates a distribution and dividends and notifies members'
  task distribution: :environment do
    NextDistributionService.distribute! if NextDistributionService.today?
  end

  desc 'recontributes unclaimed dividends and notifies member'
  task recontribution: :environment do
    if ConsolidationDateService.today?
      mailgun_send_limit = 10
      RecontributionService.new(
        issued_dividends: Dividend.issued.take(mailgun_send_limit)
      ).call
    end
  end

  desc 'creates a set of expenses every week'
  task create_expenses: :environment do
    WeeklyExpensesService.generate_and_notify if ConsolidationDateService.today?
  end

  desc 'notifies users when a distribution has settled'
  task distribution_settled: :environment do
    if ConsolidationDateService.today?
      DistributionSettledService.new(
        distribution: Distribution.last,
        users: User.active
      ).call
    end
  end

  desc 'sends a distribution preview to all users'
  task distribution_preview: :environment do
    if DistributionPreviewDateService.today?
      DistributionPreviewService.new(
        users: User.active
      ).call
    end
  end

  desc 'updates the foreign exchange rates'
  task update_foreign_exchange_rates: :environment do
    CurrencyUpdaterService.new.call
  end
end
