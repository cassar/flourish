class Dividend < ApplicationRecord
  enum status: {
    issued: 0,
    pending_pay_out: 1,
    paid: 2
  }

  belongs_to :distribution
  belongs_to :member

  def created_at_formatted
    created_at.strftime("#{created_at.day.ordinalize} %b %Y")
  end
end
