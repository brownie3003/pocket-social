class WelcomeController < ApplicationController
    def index
        if signed_in?
            @user = current_user
            if @user.pocket
                @article_feed = article_feed(@user)
            end
        end
    end
end
