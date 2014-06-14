class WelcomeController < ApplicationController

    def index
        if signed_in?
            @user = current_user
            @article_feed = order_by_date(article_feed(@user))
        end
    end
end
