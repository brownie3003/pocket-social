module PocketsHelper
    POCKET_KEY = "25676-b707d7bb4007dc7bd76ea5b4"
    POCKET_HEADERS = { "Content-Type" => "application/json", "X-Accept" => "application/json" }
    
    def request_pocket
        session[:code] = HTTParty.post("https://getpocket.com/v3/oauth/request", { headers: POCKET_HEADERS, body: { consumer_key: POCKET_KEY, redirect_uri: "www.test.com"}.to_json })["code"]
        
        puts "#{session[:code]}"
        
        redirect_to "https://getpocket.com/auth/authorize?request_token=#{session[:code]}&redirect_uri=#{pocket_auth_url}"
    end
    
    def create_pocket
        HTTParty.post("https://getpocket.com/v3/oauth/authorize",{ headers: POCKET_HEADERS, body: { consumer_key: POCKET_KEY, code: session[:code]}.to_json })
        
        # puts response
    end
end
