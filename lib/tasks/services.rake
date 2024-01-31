namespace :services do
  desc 'orchestrates a distribution'
  task distribution: :environment do
    DistributionService.new.call
  end
end
