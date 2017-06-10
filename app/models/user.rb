class User < ApplicationRecord
  has_many :activities
  
  before_save { self.email = email.downcase }

  validates :username, presence: true,
                       length: { minimum: 2, maximum: 50 },
                       uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 150 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password
  validates :role, presence: true

  has_secure_password

  ROLES = [
    ["Stock Manager", :stock_manager],
    ["Client Manager", :client_manager]
  ]

  def self.search(term)
    where("username ILIKE ?", "%#{term}%")
  end
end
