# Idempotent: safe to run more than once (bin/rails db:seed).

def seed_user(email)
  user = User.find_or_initialize_by(email:)
  if user.new_record?
    user.password = 'password'
    user.skip_confirmation_notification!
    user.confirm
    user.save!
    user.update!(last_sign_in_at: Time.current)
  end
  user.member || user.create_member!.tap(&:create_notification_preferences!)
end

# Test account for signing in locally: test@flourish.test / password
puts 'Making the test account'
test_member = seed_user('test@flourish.test')

puts 'Making some people'
people = %w[ava ben chloe dan eve finn grace hugo].map { |name| seed_user("#{name}@flourish.test") }

puts 'Making some pods'
{
  'Family' => people.first(3),
  'Friends' => people.first(6),
  'Book club' => people.last(2),
  'Neighbours' => people
}.each do |name, recipients|
  pod = Pod.find_or_create_by!(name:)
  pod.pod_memberships.find_or_create_by!(member: test_member) { |m| m.role = :contributor }
  recipients.each { |member| pod.pod_memberships.find_or_create_by!(member:) }
end
