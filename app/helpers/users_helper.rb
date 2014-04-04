module UsersHelper
    POCKET_KEY = "25676-b707d7bb4007dc7bd76ea5b4"
    POCKET_HEADERS = { "Content-Type" => "application/json", "X-Accept" => "application/json" }
    
    def user_articles
        puts "consumer_key: #{POCKET_KEY}"
        puts "access_token: #{@user.pocket.access_token}"
        HTTParty.post("https://getpocket.com/v3/get", 
        { 
            headers: POCKET_HEADERS, 
            body: {
                consumer_key: POCKET_KEY,
                access_token: @user.pocket.access_token,
                count: 10,
                detailType:"complete"
            }.to_json
        })
        # article_hash = HTTParty.get("https://getpocket.com/v3/get", 
        # { 
        #     headers: POCKET_HEADERS, 
        #     body: {
        #         consumer_key: POCKET_KEY,
        #         access_token: @user.pocket.access_token,
        #         count:"10",
        #         detailType:"complete"
        #     }
        # })
    end
end
