class User < ApplicationRecord
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true

  has_secure_password

  validates :password,
    presence: true,
    length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    BCrypt::Password.create string,
      cost: if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
  end
end
