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

  has_one :pay_out, dependent: :destroy

  scope :owed, -> { where(status: %i[issued pending_pay_out pay_out_complete]) }
end
