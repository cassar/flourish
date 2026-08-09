class PoolMembership < ApplicationRecord
  belongs_to :pool
  belongs_to :member

  enum :role, { contributor: 0, recipient: 1 }

  validates :member_id, uniqueness: { scope: :pool_id }
  validate :only_one_contributor_per_pool, if: :contributor?

  private

  def only_one_contributor_per_pool
    return unless pool.pool_memberships.contributor.where.not(id:).exists?

    errors.add(:pool, :already_has_contributor)
  end
end
