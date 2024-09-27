class AggregateStatusCountsService
  AGGREGATE_STATUSES = {
    'issued' => %w[issued],
    'paid_out' => %w[pending_pay_out pay_out_complete],
    'recontributed' => %w[manually_recontributed auto_recontributed]
  }.freeze

  def self.counts(disaggregate_status_counts)
    disaggregate_status_counts.each_with_object(Hash.new(0)) do |(disaggregate_status, count), status_counts|
      aggregate_status = aggregate_status(disaggregate_status)
      status_counts[aggregate_status] += count
    end
  end

  def self.aggregate_status(disaggregate_status)
    AGGREGATE_STATUSES.find do |aggregate_status, disaggregate_statuses|
      return aggregate_status if disaggregate_status.in? disaggregate_statuses
    end
  end
end
