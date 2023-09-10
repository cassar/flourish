class User < ApplicationRecord
  ADMIN_EMAIL = 'admin@email.com'.freeze
  ADMIN_PASSWORD = 'password'.freeze

  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_one :member, dependent: :destroy
end
