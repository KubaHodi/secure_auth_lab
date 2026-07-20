class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role,{
    user: 0,
    admin: 1
  }, default: :user, validate: true

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 20 },
            format: { with: /\A[a-zA-Z0-9_]+\z/,
                      message: "może zawierać tylko litery, cyfry i znak _" }

  validates :email_address,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
            
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
