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

  validates_presence_of :email, :password
  validates_uniqueness_of :email, :username
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email , with: VALID_EMAIL_REGEX
  
  embeds_one :pocket
  
  
  has_and_belongs_to_many :subscriptions, class_name: 'User', inverse_of: :subscribers, autosave: true
  has_and_belongs_to_many :subscribers, class_name: 'User', inverse_of: :subscriptions
  
  def subscribe!(user)
    if self.id != user.id && !self.subscriptions.include?(user)
      self.subscriptions << user
      user.subscribers << self
    end
  end

  def unsubscribe!(user)
    self.subscriptions.delete(user)
  end
  
  # Should probably add a salt if ever going to production
  def User.new_remember_token
    # SecureRandom.urlsafe_base64
    rand(20)
  end

  # def User.digest(token)
  #   Digest::SHA1.hexdigest(token.to_s)
  # end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
