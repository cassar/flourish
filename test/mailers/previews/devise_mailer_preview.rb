class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.first || User.new(email: 'test@example.com')
    CustomDeviseMailer.confirmation_instructions(user, 'faketoken')
  end

  def reset_password_instructions
    user = User.first || User.new(email: 'test@example.com')
    CustomDeviseMailer.reset_password_instructions(user, 'faketoken')
  end

  def email_changed
    user = User.first || User.new(email: 'test@example.com')
    CustomDeviseMailer.email_changed(user)
  end

  def password_change
    user = User.first || User.new(email: 'test@example.com')
    CustomDeviseMailer.password_change(user)
  end
end
