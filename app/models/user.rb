class User
    include Mongoid::Document
    include Mongoid::Timestamps
    
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

    ## Database authenticatable
    field :username,           type: String, default: ""
    field :email,              type: String, default: ""
    field :encrypted_password, type: String, default: ""
    field :twitter_following,  type: Array, default: []
    field :bio,                type: String, default: ""
    field :image,              type: String, default: ""
    field :new_user?,          type: Boolean, default: true

    ## Omniauthable
    field :provider, type: String, default: ""
    field :uid,      type: String, default: ""

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

    # Removing normal sign up and username
    # validates_presence_of :username, message: "can't be blank"
    # validates_uniqueness_of :username, message: "already taken"

    
    # Must use username as ID because .com of email doesn't work for routes
    field :_id, type: String, default: ->{ username }

    embeds_one :pocket
    
    has_and_belongs_to_many :subscriptions, class_name: 'User', inverse_of: :subscribers, autosave: true
    has_and_belongs_to_many :subscribers, class_name: 'User', inverse_of: :subscriptions

    def self.from_omniauth(auth)
        where(auth.slice(:provider, :uid)).first_or_create do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.username = auth.info.nickname
            user.bio = auth.info.description
            user.image = auth.info.image
        end
    end 

    # Model fails to save from omniauth because email is not present
    def self.new_with_session(params, session)
        if session["devise.user_attributes"]
            client = Twitter::REST::Client.new do |config|
                config.consumer_key        = ENV['TWITTER_KEY']
                config.consumer_secret     = ENV['TWITTER_SECRET']
                config.access_token        = session["twitter_token"]
                config.access_token_secret = session["twitter_secret"]
            end

            following = client.friend_ids.to_set

            users_list = Set.new
            User.all.each do |user|
                if user.pocket
                    users_list << user.uid.to_i
                end
            end

            twitter_following = (users_list&(following)).to_a

            new(session["devise.user_attributes"]) do |user|
                puts "User attributes: #{user.attributes}"
                user.attributes = params
                user.update_attributes(twitter_following: twitter_following)
                user.valid?
            end
        else
            # No session? -> Fall back to registering a user the normal way with devise
            super
        end
    end

    def subscribe!(user)
        if self.id != user.id && !self.subscriptions.include?(user)
            self.subscriptions << user
            user.subscribers << self
            # If this is someone we would recommend they follow
            self.twitter_following.delete(user.uid.to_i)
            self.save
        end
    end

    def unsubscribe!(user)
        self.subscriptions.delete(user)
    end
    
    def self.search(search)
        if search
            where(username: /#{Regexp.escape(search)}/i)
        else
            all
        end
    end

    # Don't require a password with devise if we are using a provider (twitter)
    def password_required?
        super && provider.blank?
    end
end
