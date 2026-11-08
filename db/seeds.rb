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

puts 'Making some pods'
if test_member.pods.none?
  [people.first(3), people.first(6), people.last(2), people].each do |recipients|
    pod = Pod.create!
    pod.pod_memberships.create!(member: test_member, role: :contributor)
    recipients.each { |member| pod.pod_memberships.create!(member:) }
  end
end

puts 'Making some distributions'
test_member.contributor_pods.order(:id).each_with_index do |pod, index|
  next if pod.distributions.any?

  [12_000, 4_550, 25_000, 800].first(index + 1).each.with_index(1) do |cents, number|
    pod.distributions.create!(number:, amount_in_base_units: cents)
  end
end
