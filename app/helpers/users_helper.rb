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
    
    def add_article_helper article, access_token
        HTTParty.post("https://getpocket.com/v3/add",{ headers: POCKET_HEADERS, body: { url: article, consumer_key: POCKET_KEY, access_token: access_token}.to_json })
    end
    
    def article_feed user
        state = "all"
        time = (Time.now - 2.weeks)
        
        article_feed = array.new
        user.subscriptions.each
    end
end
