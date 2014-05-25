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
        
        # Delete any unresolved articles from hash (or IFTTT articles from Mr. Clifford)
        articles.each do |id, article|
            if article["resolved_url"].nil? || article["resolved_title"] == "Missing Link"
                articles.delete(id)
            end
        end
        
        return articles
    end

    # returns a list of the last 2 weeks of articles that subscriptions have added to their pocket
    def subscription_articles(user)
        subscription_articles = { 1 => {"resolved_id" => "placeholder"}}
        copy_of_subscription_articles = { 1 => {"resolved_id" => "placeholder"}}

        # |subscription| is another user that our user is subscribed to
        user.subscriptions.each do |subscription_user|
            user_articles(subscription_user, 'all', (Time.now - 2.weeks)).each do |subscription_article_id, subscription_article_hash|
                copy_of_subscription_articles.each do |article_id, article_hash|
                    if article_hash["resolved_id"] == subscription_article_hash["resolved_id"]
                        # article_hash[:being_read_by] << subscription_user.username
                        # puts "add user id: #{article_id}"
                        subscription_articles[article_id][:being_read_by] << subscription_user.username 
                    else
                        subscription_articles[subscription_article_id] = subscription_article_hash
                        subscription_articles[subscription_article_id][:being_read_by] = [subscription_user.username]
                    end
                end
                copy_of_subscription_articles.merge!(subscription_articles)
            end
        end
        subscription_articles.delete(1)
        return subscription_articles
    end
    

    def article_feed(user)
        user_articles = user_articles(user, 'all')
        subscription_articles = subscription_articles(user)
        prune_articles(user_articles, subscription_articles)
    end


    def prune_articles(user, subscriptions)
        subscriptions.each do |subscription_article_id, subscription_article_hash|
            user.each do |users_article_id, users_article_hash|
                if users_article_hash["resolved_id"] == subscription_article_hash["resolved_id"] or users_article_hash["resolved_url"].include? "ifttt"
                    subscriptions.delete(subscription_article_id)
                end
            end 
        end
        return subscriptions
    end

    def order_by_popularity(articles)
        articles.sort_by{ |id, article| article[:being_read_by].count }.reverse
    end

    def order_by_date(articles)
        articles.sort_by{ | id, article| article["time_updated"] }
    end

    def randomize_articles(articles)
        articles = Hash[articles.to_a.shuffle]
    end
    
    def add_article_helper article, access_token
        HTTParty.post("https://getpocket.com/v3/add",{ headers: POCKET_HEADERS, body: { url: article, consumer_key: POCKET_KEY, access_token: access_token}.to_json })
    end
end
