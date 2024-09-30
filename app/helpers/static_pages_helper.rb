module StaticPagesHelper
  def next_distribution_date_formatted
    DistributionDateService.next_date.strftime('%a, %d %b %Y')
  end

  def created_at_formatted(record)
    record.created_at.strftime("%A, #{record.created_at.day.ordinalize} %b %Y")
  end
end
