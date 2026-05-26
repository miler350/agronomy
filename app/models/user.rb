class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { client: 0, admin: 1 }, default: :client

  WHITELIST = %w[
    cordis@brickroad.io
    katie@k2agronomy.com
    grogankatie23@gmail.com
    joshlamb@vt.edu
    johnlambii10@yahoo.com
  ].freeze

  def active_for_authentication?
    super && WHITELIST.include?(email.downcase)
  end

  def inactive_message
    WHITELIST.include?(email.downcase) ? super : :invalid
  end

  def admin?
    role == "admin"
  end
end
