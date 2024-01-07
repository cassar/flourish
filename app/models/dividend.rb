class Dividend < ApplicationRecord
  enum status: {
    issued: 0,
    pending_pay_out: 1,
    paid: 2
  }

  belongs_to :distribution
  belongs_to :member

  before_save :check_paid_status

  def created_at_formatted
    created_at.strftime("#{created_at.day.ordinalize} %b %Y")
  end

  private

  def check_paid_status
    self.status = :paid if receipt.present?
  end
end
