class User < ApplicationRecord
  ADMIN_EMAIL = "admin@email.com"
  ADMIN_PASSWORD = "password"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :member, dependent: :destroy
end
