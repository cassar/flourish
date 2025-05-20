namespace :services do
  desc 'creates a set of expenses every week'
  task create_expenses: :environment do
    WeeklyExpensesService.generate_and_notify if ConsolidationDate.today?
  end

  desc 'sends a distribution preview email to all subscribed members'
  task distribution_preview: :environment do
    if DistributionPreviewDate.today?
      users = User.active.distribution_preview_notify_enabled

      DistributionPreviewService.new(users:).call
    end
  end

  desc 'posts a distribution preview to bluesky'
  task bluesky_distribution_preview: :environment do
    BlueskyDistributionPreview.new.call if DistributionPreviewDate.today?
  end

  desc 'creates a distribution and dividends and email notifies subscribed members'
  task distribute_dividends: :environment do
    NextDistribution.distribute! if NextDistribution.today?
  end

  desc 'recontributes unclaimed dividends and email notifies subscribed members'
  task recontribute_dividends: :environment do
    if ConsolidationDate.today?
      mailgun_send_limit = 10
      issued_dividends = Dividend.issued.take(mailgun_send_limit)
      notify_enabled_dividends = Dividend.where(id: issued_dividends)
        .automatically_recontributed_notify_enabled

      RecontributionService.new(issued_dividends:, notify_enabled_dividends:).call
    end
  end

  desc 'email notifies subscribed members when a distribution has settled'
  task distribution_settled: :environment do
    if ConsolidationDate.today?
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
