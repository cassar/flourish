class Dividend < ApplicationRecord
  enum status: {
    issued: 0,
    pay_out: 1
  }

  belongs_to :distribution
  belongs_to :member
end
