class Dividend < ApplicationRecord
  enum :status, {
    issued: 0,
    pending_pay_out: 1,
    paid_out: 2,
    recontributed: 3,
    auto_recontributed: 4
  }

  belongs_to :distribution
  belongs_to :member

  scope :owed, -> { not_recontributed }

  before_save :check_for_receipt

  private

  def check_for_receipt
    self.status = :paid_out if receipt.present?
  end
end
