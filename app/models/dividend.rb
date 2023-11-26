class Dividend < ApplicationRecord
  belongs_to :distribution
  belongs_to :member
end
