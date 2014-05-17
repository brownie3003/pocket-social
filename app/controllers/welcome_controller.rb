class WelcomeController < ApplicationController
    def index
        @user = current_user
        @article_feed = article_feed(@user)
    end
end
