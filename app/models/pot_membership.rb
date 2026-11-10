class PotMembership < ApplicationRecord
  belongs_to :pot
  belongs_to :member

  enum :role, { contributor: 0, recipient: 1 }

  validates :member_id, uniqueness: { scope: :pot_id }
  validate :only_one_contributor_per_pot, if: :contributor?

  private

  def only_one_contributor_per_pot
    return unless pot.pot_memberships.contributor.where.not(id:).exists?

    errors.add(:pot, :already_has_contributor)
  end
end
