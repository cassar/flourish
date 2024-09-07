namespace :services do
  desc 'orchestrates a distribution'
  task distribution: :environment do
    DistributionService.new(
      run_today: DistributionDateService.today?,
      members: Member.active,
      total_pool_in_base_units: TotalPoolService.balance_in_base_units
    ).call
  end

  desc 'recontributes unclaimed dividends'
  task recontribution: :environment do
    RecontributionService.new.call
  end
end
