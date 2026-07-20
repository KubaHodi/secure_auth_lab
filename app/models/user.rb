class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 20 },
            format: { with: /\A[a-zA-Z0-9_]+\z/,
                      message: "może zawierać tylko litery, cyfry i znak _" }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
