class User < ApplicationRecord
  ADMIN_EMAIL = ENV['ADMIN_EMAIL'] || "admin@#{ENV.fetch('DOMAIN', nil)}".freeze

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :trackable

  has_one :member, dependent: :destroy

  def admin?
    email == ADMIN_EMAIL
  end
end
