class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  field :username
  field :email
  # Must use username as ID because .com of email doesn't work for routes
  field :_id, type: String, default: ->{ username }

  field :password_digest
  field :remember_token

  has_secure_password

  field :pocket, type: Hash

  validates_presence_of :email, :password
  validates_uniqueness_of :email, :username
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email , with: VALID_EMAIL_REGEX
  
  # Should probably add a salt if ever going to production
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
