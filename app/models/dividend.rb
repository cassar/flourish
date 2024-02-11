class Dividend < ApplicationRecord
  enum status: {
    issued: 0,
    pending_pay_out: 1,
    paid_out: 2,
    recontributed: 3
  }

  belongs_to :distribution
  belongs_to :member

  scope :outstanding, -> { where(status: %i[issued pending_pay_out]) }

  before_save :check_for_receipt

  def created_at_formatted
    created_at.strftime("#{created_at.day.ordinalize} %b %Y")
  end

  private

  def check_for_receipt
    self.status = :paid_out if receipt.present?
  end
end
