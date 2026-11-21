class PotMembership < ApplicationRecord
  belongs_to :pot
  belongs_to :member

  validates :member_id, uniqueness: { scope: :pot_id }
end
