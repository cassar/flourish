class Pod < ApplicationRecord
  has_many :pod_memberships, dependent: :destroy
  has_many :members, through: :pod_memberships
  has_many :distributions, dependent: :nullify
  has_many :contributions, dependent: :nullify

  validates :name, presence: true

  def contributor_membership
    pod_memberships.contributor.first
  end

  def contributor
    contributor_membership&.member
  end

  def recipient_memberships
    pod_memberships.recipient
  end

  def recipients
    members.merge(PodMembership.recipient)
  end
end
