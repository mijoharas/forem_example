class User < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 50 }
  ##
  # Regex to check whether something is a valid email or not
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }

  has_secure_password
  before_save { email.downcase! }
  before_save { generate_token(:remember_token)}

  def to_s
    name
  end

  ##
  # Generates a unique token with a random string of characters
  # (for remember_tokens, e.t.c)
  def generate_token(column) #:doc:
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
