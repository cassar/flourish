namespace :services do
  desc 'creates a set of expenses every week'
  task create_expenses: :environment do
    WeeklyExpensesService.generate_and_notify if ConsolidationDateService.today?
  end

  desc 'sends a distribution preview to all subscribed users'
  task distribution_preview: :environment do
    if DistributionPreviewDateService.today?
      users = User.active.distribution_preview_notify_enabled

      DistributionPreviewService.new(users:).call
    end
  end

  desc 'creates a distribution and dividends and notifies members'
  task distribute_dividends: :environment do
    NextDistribution.distribute! if NextDistribution.today?
  end

  desc 'recontributes unclaimed dividends and notifies subscribed members'
  task recontribute_dividends: :environment do
    if ConsolidationDateService.today?
      mailgun_send_limit = 10
      issued_dividends = Dividend.issued.take(mailgun_send_limit)
      notify_enabled_dividends = Dividend.where(id: issued_dividends)
        .automatically_recontributed_notify_enabled

      RecontributionService.new(issued_dividends:, notify_enabled_dividends:).call
    end
  end

  desc 'notifies users when a distribution has settled'
  task distribution_settled: :environment do
    if ConsolidationDateService.today?
      users = User.active.distribution_settled_notify_enabled

      DistributionSettledNotificationService.new(distribution: Distribution.last, users:).call
    end
  end

  desc 'updates the foreign exchange rates'
  task update_foreign_exchange_rates: :environment do
    CurrencyUpdaterService.call
  end

  desc 'destroys inactive users older than a certain time'
  task destroy_old_inactive_users: :environment do
    User.inactive.where(created_at: ...1.day.ago).destroy_all
  end
end
