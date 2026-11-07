namespace :services do
  desc 'creates a distribution and dividends for every pod'
  task distribute_dividends: :environment do
    Pod.find_each do |pod|
      NextDistribution.new(pod:).distribute!
    rescue StandardError => e
      ActivityLog.create(message: "Distribution failed for pod ##{pod.id} (#{pod.name}): #{e.message}")
    end
  end

  desc 'recontributes unclaimed dividends'
  task recontribute_dividends: :environment do
    batch_size = 10
    issued_dividends = Dividend.issued.take(batch_size)

    RecontributionService.new(issued_dividends:).call
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
