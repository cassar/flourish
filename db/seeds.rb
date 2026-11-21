# Idempotent: safe to run more than once (bin/rails db:seed).

def seed_user(email, name)
  user = User.find_or_initialize_by(email:)
  if user.new_record?
    user.password = 'password'
    user.skip_confirmation_notification!
    user.confirm
    user.save!
    user.update!(last_sign_in_at: Time.current)
  end
  member = user.member || user.create_member!.tap(&:create_notification_preferences!)
  member.update!(name:) if member.name.blank?
  member
end

# Test account for signing in locally: test@flourish.test / password
puts 'Making the test account'
test_member = seed_user('test@flourish.test', 'Test')

puts 'Making some people'
people = %w[Ava Ben Chloe Dan Eve Finn Grace Hugo].map { |name| seed_user("#{name.downcase}@flourish.test", name) }

puts 'Making some pots'
if test_member.pots.none?
  [people.first(3), people.first(6), people.last(2), people].each do |others|
    pot = Pot.create!
    [test_member, *others].each { |member| pot.pot_memberships.create!(member:) }
  end
end

puts 'Making some distributions'
test_member.pots.order(:id).each_with_index do |pot, index|
  next if pot.distributions.any?

  members = pot.members.order(:id).to_a
  [12_000, 4_550, 25_000, 800].first(index + 1).each.with_index(1) do |cents, number|
    distribution = pot.distributions.create!(number:, amount_in_base_units: cents)

    # Each distribution pays out one member's contribution; they take turns.
    distribution.create_contribution!(pot:, member: members[(number - 1) % members.size],
                                      amount_in_base_units: cents,
                                      transaction_identifier: "seed-contribution-#{distribution.id}")

    # Paid to the first two people who didn't contribute it, an equal share each.
    recipients = distribution.recipients.order(:id).first(2)
    share = distribution.amounts.create!(currency: 'AUD', amount_in_base_units: cents / recipients.size)
    recipients.each do |member|
      dividend = share.dividends.create!(member:, status: :paid_out)
      dividend.create_pay_out!(amount_in_base_units: share.amount_in_base_units,
                               transaction_identifier: "seed-#{distribution.id}-#{member.id}")
    end
  end
end
