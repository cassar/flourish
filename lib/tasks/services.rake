namespace :services do
  desc 'orchestrates a distribution'
  task distribution: :environment do
    DistributionService.new.call
  end

  desc 'retrieves and saves new contributions'
  task contributions: :environment do
    ContributionsParserService.new.call
  end
end
