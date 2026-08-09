namespace :services do
  # distribution_preview / bluesky_distribution_preview / mastodon_distribution_preview
  # are disabled pending a multi-pool redesign: DistributionPreviewService,
  # BlueskyDistributionPreview, and MastodonDistributionPreview all reference the
  # global NextDistribution singleton that the pool refactor removed, and a member
  # can now be a recipient in more than one pool, so "which pool's preview" needs a
  # product decision before these are re-enabled.
  desc 'DISABLED (multi-pool redesign pending): sends a distribution preview email to all subscribed members'
  task distribution_preview: :environment do
  end

  desc 'DISABLED (multi-pool redesign pending): posts a distribution preview to bluesky'
  task bluesky_distribution_preview: :environment do
  end

  desc 'DISABLED (multi-pool redesign pending): posts a distribution preview to mastodon'
  task mastodon_distribution_preview: :environment do
  end

  desc 'creates a distribution and dividends for every pool, and email notifies subscribed members'
  task distribute_dividends: :environment do
    if NextDistribution.today?
      Pool.find_each do |pool|
        NextDistribution.new(pool:).distribute!
      rescue StandardError => e
        ActivityLog.create(message: "Distribution failed for pool ##{pool.id} (#{pool.name}): #{e.message}")
      end
    end
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

  desc 'email notifies subscribed members when a pool distribution has settled'
  task distribution_settled: :environment do
    if ConsolidationDate.today?
      Pool.find_each do |pool|
        distribution = pool.distributions.order(:number).last
        next unless distribution

        users = User.active.distribution_settled_notify_enabled
          .where(id: pool.members.select(:user_id))

        DistributionSettledNotificationService.new(distribution:, users:).call
      rescue StandardError => e
        ActivityLog.create(
          message: "Distribution settled notification failed for pool ##{pool.id} (#{pool.name}): #{e.message}"
        )
      end
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
