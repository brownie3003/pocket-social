module UsersHelper
    POCKET_KEY = "25676-b707d7bb4007dc7bd76ea5b4"
    POCKET_HEADERS = { "Content-Type" => "application/json", "X-Accept" => "application/json" }
    
    def user_articles user
        HTTParty.post("https://getpocket.com/v3/get", 
        { 
            headers: POCKET_HEADERS, 
            body: {
                consumer_key: POCKET_KEY,
                access_token: user.pocket.access_token,
                count: 10,
                detailType:"complete"
            }.to_json
        })
    end
    
    def add_article_helper article, access_token
        HTTParty.post("https://getpocket.com/v3/add",{ headers: POCKET_HEADERS, body: { url: article, consumer_key: POCKET_KEY, access_token: access_token}.to_json })
    end
end
