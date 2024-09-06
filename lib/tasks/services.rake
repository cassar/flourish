namespace :services do
  desc 'orchestrates a distribution'
  task distribution: :environment do
    DistributionService.new.call
  end

  desc 'recontributes unclaimed dividends'
  task recontribute: :environment do
    RecontributionService.new.call
  end
end
