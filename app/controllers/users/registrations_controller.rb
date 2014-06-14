class Users::RegistrationsController < Devise::RegistrationsController
    def create
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_KEY']
            config.consumer_secret     = ENV['TWITTER_SECRET']
            # config.access_token        = session["twitter_token"]
            # config.access_token_secret = session["twitter_secret"]
        end

        following = client.following("nicangeli")
        
        following_list = Set.new
        
        following.each do |user|
            following_list << user.screen_name
        end

        users_list = Set.new
        User.all.each do |user|
            users_list << user.username
        end

        twitter_following = (users_list&(following_list)).to_a
        super
    end
end