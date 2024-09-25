class Dividend < ApplicationRecord
  enum :status, {
    issued: 0,
    pending_pay_out: 1,
    pay_out_complete: 2,
    manually_recontributed: 3,
    auto_recontributed: 4
  }

  AGGREGATE_STATUSES = {
    issued: %i[issued],
    paid_out: %i[pending_pay_out pay_out_complete],
    recontributed: %i[manually_recontributed auto_recontributed]
  }.freeze

  belongs_to :distribution
  belongs_to :member

  scope :owed, -> { where.not(status: %i[manually_recontributed auto_recontributed]) }

  before_save :check_for_receipt

  def self.aggregate_status(disaggregate_status)
    Dividend::AGGREGATE_STATUSES.find do |aggregate_status, disaggregate_statuses|
      return aggregate_status if disaggregate_status.in? disaggregate_statuses
    end
  end

  private

  def check_for_receipt
    self.status = :pay_out_complete if receipt.present?
  end
end
