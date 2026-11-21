class Pot < ApplicationRecord
  has_many :pot_memberships, dependent: :destroy
  has_many :members, through: :pot_memberships
  has_many :distributions, dependent: :nullify
  has_many :contributions, dependent: :nullify
end
