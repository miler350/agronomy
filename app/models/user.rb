class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { client: 0, admin: 1 }, default: :client

  def admin?
    role == "admin"
  end
end
