class UserMailer < ActionMailer::Base
    add_template_helper(UsersHelper)
    default from: "team@pocket-social.com"
    
    def recommendations_email user
        
        @user = user
        
        # We have 3 cases
        # 1. User doesn't have any subscriptions (they may have associated their pocket though?)
        # 2. User has subscriptions but hasn't associated their pocket 
        # 3. User has subscriptions and has associated their pocket
        
        # Should return @recommendation_array to be used in the email
        
        # Case 1
        if user.subscriptions.empty?
            
            @recommendation_array = get_all_articles
            
        else
            
            # Case 2
            if user.pocket.nil?
                user_articles = []
            else
                
                # Case 3
                user_articles = user_articles(@user, "all")
            end
            
            subscription_articles = get_subscription_articles(@user)
            
            recommendation_articles = find_recommendation_articles(user_articles, subscription_articles)
            
            @recommendation_array = build_recommendations(recommendation_articles)
            
        end
        
        mail(to: user.email , subject: "Weekly article recommendations from Pocket-Social", bcc: "brownie3003@gmail.com")
    end
    

    
    private
    
        def get_all_articles
            recommendation_array = Array.new
            
            User.each do |user|
                
                if user.pocket.nil?
                    # If the user has no pocket then we can't get any articles from them
                    next
                else
                    
                    create_articles_array recommendation_array, user
                    
                end
            end
            
            build_recommendations (recommendation_array)
        end
    
        # Method that gets all articles that are available from subscriptions
        def get_subscription_articles user
            
            # Create an array to put each article in
            subscription_articles = Array.new
            
            # Loop over each subcription object
            user.subscriptions.each do |user|
                
                create_articles_array subscription_articles, user
                
            end
            
            return subscription_articles
        end
        
        def create_articles_array articles_array, user
            
            # Loop over each article from the subscription user in this loop
            user_articles(User.find_by(id: user[:id]), "all", (Time.now - 2.weeks)).each do |id, article|
                
                # Matt Clifford uses IFTT which regularly doesn't get an article.
                if article["resolved_url"].include? "ifttt"
                    next
                # If we can not find an element that has a url key with the same value as the articles url 
                elsif articles_array.select{|element| element[:url] == article["resolved_url"]}.empty?
                    
                    # We need to push this article into our array with certain paramaters.
                    articles_array << {
                        url: article["resolved_url"], 
                        title: article["resolved_title"], 
                        excerpt: article["excerpt"], 
                        being_read_by: [user[:id]]
                    }
                
                # In the case where we do find a match, i.e the above is true
                else
                    
                    # Get the index of the element where the url matches the article url
                    index = articles_array.index{|element| element[:url] == article["resolved_url"]}
                    
                    # Append the subscription user to the :being_read_by key of the hash
                    articles_array[index][:being_read_by] << user[:id]
                end
            end
            
            return articles_array
            
        end
        
        def find_recommendation_articles user_articles, subscription_articles
            
            # loop over subscription articles and check whether it is in user_articles (by resolved URL) if it is remove from subscription_articles
            user_articles_urls = Array.new
            user_articles_titles = Array.new
            
            # For some reason only urls wasn't always catching articles, so will check against urls and titles
            user_articles.each do |id, article|
                user_articles_urls << article["resolved_url"]
                user_articles_titles << article["resolved_title"]
            end
            
            # Loop over the subscription articles array
            subscription_articles.each do |article|
                # If this article's URL can be found in user_articles_urls then remove it from the subscription articles because we've already read it
                if user_articles_urls.include? article[:url] or user_articles_titles.include? article[:title]
                    subscription_articles.delete(article)
                    puts "deleted #{article}"
                end
            end
            
            return subscription_articles
            
        end
        
        # Move articles that are being read by more of your network to the top of the array so they get recommended.
        def build_recommendations (recommendation_articles)
            recommendation_articles.sort_by!{ |article| article[:being_read_by].count }.reverse
        end
        
end
