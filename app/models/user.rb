class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  before_save { self.email = email.downcase }

  field :username
  field :email
  # Must use username as ID because .com of email doesn't work for routes
  field :_id, type: String, default: ->{ username }

  field :password_digest

  has_secure_password

  field :pocket, type: Hash

  validates_presence_of :email, :password
  validates_uniqueness_of :email, :username
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email , with: VALID_EMAIL_REGEX
end
