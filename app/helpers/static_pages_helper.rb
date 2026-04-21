module StaticPagesHelper
  def created_at_formatted(record)
    date = record.created_at.to_datetime
    date.strftime("%a, #{date.day.ordinalize} %b %Y")
  end
end
