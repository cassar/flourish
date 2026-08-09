class Pool < ApplicationRecord
  has_many :pool_memberships, dependent: :destroy
  has_many :members, through: :pool_memberships
  has_many :distributions, dependent: :nullify
  has_many :contributions, dependent: :nullify

  validates :name, presence: true

  def contributor_membership
    pool_memberships.contributor.first
  end

  def contributor
    contributor_membership&.member
  end

  def recipient_memberships
    pool_memberships.recipient
  end

  def recipients
    members.merge(PoolMembership.recipient)
  end
end
