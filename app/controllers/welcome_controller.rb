class WelcomeController < ApplicationController

    def index
        if signed_in?
            @user = current_user
            @article_feed = order_by_date(article_feed(@user))

            client = Twitter::REST::Client.new do |config|
                config.consumer_key        = ENV['TWITTER_KEY']
                config.consumer_secret     = ENV['TWITTER_SECRET']
                # config.access_token        = session["twitter_token"]
                # config.access_token_secret = session["twitter_secret"]
            end

            following = client.following("UBC_founder")
            
            following_list = Set.new
            
            following.each do |user|
                following_list << user.screen_name
            end

            users_list = Set.new
            User.all.each do |user|
                users_list << user.username
            end

            @twitter_following = (users_list&(following_list)).to_a

            current_user.update_attributes(twitter_following: @twitter_following)

        end
    end
end
