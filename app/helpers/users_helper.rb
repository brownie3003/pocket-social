module UsersHelper
    POCKET_KEY = "25676-b707d7bb4007dc7bd76ea5b4"
    POCKET_HEADERS = { "Content-Type" => "application/json", "X-Accept" => "application/json" }
    
    # Get user articles from a users pocket
    # params: user to check their pocket, state of articles to retrieve ("unread", "archive", "all"), time: How long ago to look for must be in unix timestamp (optional)
    def user_articles user, state, *time
        time = time[0].to_i
        
        articles = HTTParty.post("https://getpocket.com/v3/get", 
        { 
            headers: POCKET_HEADERS, 
            body: {
                consumer_key: POCKET_KEY,
                access_token: user.pocket.access_token,
                detailType:"complete",
                sort: "newest",
                since: time,
                state: state 
            }.to_json
        })["list"]
        
        # Delete any unresolved articles from hash
        articles.each do |id, article|
            if article["resolved_url"].nil?
                articles.delete(id)
            end
        end
        
        return articles
    end

    # returns a list of the last 5 days of articles that subscriptions have added to their pocket
    def subscription_articles(user)
        subscription_articles = {}

        # |subscription| is another user that our user is subscribed to
        user.subscriptions.each do |subscription|
            user_articles(subscription, 'all', (Time.now - 5.days)).each do |id, article|
                
                if subscription_articles.has_key?(id)
                    # Add the name of the user to the :being_read_by field.
                    subscription_articles[:id][:being_read_by] << subscription.username
                else
                    # Add article to subscription_articles
                    subscription_articles.store(id, article)
                    
                    # Add new key value pair being_read_by: "subscription.username"
                    subscription_articles[id][:being_read_by] = [subscription.username]
                end
            end
        end
        return subscription_articles
    end
    
    def add_article_helper article, access_token
        HTTParty.post("https://getpocket.com/v3/add",{ headers: POCKET_HEADERS, body: { url: article, consumer_key: POCKET_KEY, access_token: access_token}.to_json })
    end

    def article_feed(user)
        user_articles = user_articles(user, 'all')
        subscription_articles = subscription_articles(user)
        prune_articles(user_articles, subscription_articles)
    end


    def prune_articles(user, subscriptions)
        subscriptions.each do |subscription_article_id, subscription_article_hash|
            user.each do |users_article_id, users_article_hash|
                if users_article_hash["resolved_id"] == subscription_article_hash["resolved_id"]
                    subscriptions.delete(subscription_article_id)
                end
            end 
        end
        return subscriptions
    end
end
