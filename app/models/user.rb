class User
    include Mongoid::Document
    include ActiveModel::SecurePassword

    before_save { self.email = email.downcase }

    field :username
    field :email
    # Must use username as ID because .com of email doesn't work for routes
    field :_id, type: String, default: ->{ username }

    field :password_digest
    field :remember_token

    has_secure_password

    validates_presence_of :email, :username
    validates_length_of :username, maximum: 26, message: "Whoa, that username is too long."
    validates_length_of :password, minimum: 8, maximum: 16, message: "Password should be between 8 - 16 characters... We hate passwords too."
    validates_uniqueness_of :email, case_sensitive: false
    validates_uniqueness_of :username, case_sensitive: false
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
    
end
