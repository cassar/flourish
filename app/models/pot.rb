class Pot < ApplicationRecord
  has_many :pot_memberships, dependent: :destroy
  has_many :members, through: :pot_memberships
  has_many :distributions, dependent: :nullify
  has_many :contributions, dependent: :nullify

  def contributor_membership
    pot_memberships.contributor.first
  end

  def contributor
    contributor_membership&.member
  end

  def recipient_memberships
    pot_memberships.recipient
  end

  def recipients
    members.merge(PotMembership.recipient)
  end
end
