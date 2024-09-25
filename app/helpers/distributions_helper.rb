module DistributionsHelper
  def aggregate_status_counts(disaggregate_status_counts)
    disaggregate_status_counts.each_with_object(Hash.new(0)) do |(disaggregate_status, count), status_counts|
      aggregate_status = Dividend.aggregate_status(disaggregate_status.to_sym).to_s
      status_counts[aggregate_status] += count
    end
  end
end
