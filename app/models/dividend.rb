class Dividend < ApplicationRecord
  enum :status, {
    issued: 0,
    pending_pay_out: 1,
    pay_out_complete: 2,
    manually_recontributed: 3,
    auto_recontributed: 4
  }

  belongs_to :member
  belongs_to :amount

  has_one :distribution, through: :amount
  has_one :pay_out, dependent: :destroy

  scope :owed, -> { where(status: %i[issued pending_pay_out]) }
  scope :recontributed, -> { where(status: %i[manually_recontributed auto_recontributed]) }
end
