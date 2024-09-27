class Dividend < ApplicationRecord
  enum :status, {
    issued: 0,
    pending_pay_out: 1,
    pay_out_complete: 2,
    manually_recontributed: 3,
    auto_recontributed: 4
  }

  belongs_to :distribution
  belongs_to :member

  scope :owed, -> { where(status: %i[issued pending_pay_out pay_out_complete]) }

  before_save :check_for_receipt

  private

  def check_for_receipt
    self.status = :pay_out_complete if receipt.present?
  end
end
