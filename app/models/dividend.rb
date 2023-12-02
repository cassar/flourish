class Dividend < ApplicationRecord
  enum status: {
    issued: 0,
    pay_out: 1
  }

  belongs_to :distribution
  belongs_to :member

  def created_at_formatted
    created_at.strftime("#{created_at.day.ordinalize} %b %Y")
  end
end