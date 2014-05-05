class User
    include Mongoid::Document
    include Mongoid::Timestamps

    before_save { self.email = email.downcase }

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
     :recoverable, :rememberable, :trackable, :validatable

    ## Database authenticatable
    field :username,           type: String, default: ""
    field :email,              type: String, default: ""
    field :encrypted_password, type: String, default: ""
    
    # Must use username as ID because .com of email doesn't work for routes
    field :_id, type: String, default: ->{ username }

    ## Recoverable
    field :reset_password_token,   type: String
    field :reset_password_sent_at, type: Time

    ## Rememberable
    field :remember_created_at, type: Time

    ## Trackable
    field :sign_in_count,      type: Integer, default: 0
    field :current_sign_in_at, type: Time
    field :last_sign_in_at,    type: Time
    field :current_sign_in_ip, type: String
    field :last_sign_in_ip,    type: String

    ## Confirmable
    # field :confirmation_token,   type: String
    # field :confirmed_at,         type: Time
    # field :confirmation_sent_at, type: Time
    # field :unconfirmed_email,    type: String # Only if using reconfirmable

    ## Lockable
    # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
    # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
    # field :locked_at,       type: Time
    
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
