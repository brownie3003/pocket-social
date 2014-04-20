class UserMailer < ActionMailer::Base
    add_template_helper(UsersHelper)
    default from: "team@pocket-social.com"
    
    def recommendations_email user
        
        @user = user
        
        # Dirty code for users that  have not subscribed to anyone to give them a load of recommendations
        if user.subscriptions.empty?
            @recommendation_array = Array.new
            
            User.each do |user|
                
                if user.pocket.nil?
                    # If the user has no 
                    next
                else
                    user_articles(User.find_by(id: user.id), "all", (Time.now - 2.weeks)).each do |id, article|
                        
                        if article["resolved_url"].include? "ifttt"
                            next
                        elsif @recommendation_array.select{|element| element[:url] == article["resolved_url"]}.empty?
                            
                            # We need to push this article into our array with certain paramaters.
                            @recommendation_array << {
                                url: article["resolved_url"], 
                                title: article["resolved_title"], 
                                excerpt: article["excerpt"], 
                                being_read_by: [user[:id]]
                            }
                        
                        # In the case where we do find a match, i.e the above is true
                        else
                            
                            # Get the index of the element where the url matches the article url
                            index = @recommendation_array.index{|element| element[:url] == article["resolved_url"]}
                            
                            # Append the subscription user to the :being_read_by key of the hash
                            @recommendation_array[index][:being_read_by] << user[:id]
                        end        
                    end
                end
            end
            
            @recommendation_array.sort_by!{ |article| article[:being_read_by].count }.reverse
            
        else
            
            if user.pocket.nil?
                user_articles = []
            else
                user_articles = user_articles(@user, "all")
            end
            
            subscription_articles = get_subscription_articles(@user)
            
            recommendation_articles = find_recommendation_articles(user_articles, subscription_articles)
            
            @recommendation_array = build_recommendations(recommendation_articles)
            
        end
        
        mail(to: user.email , subject: "Weekly article recommendations from Pocket-Social", bcc: "brownie3003@gmail.com")
    end
    
    def add_article_from_email article, user    
        add_article_helper article, user.pocket.access_token
        redirect_to User.find_by(id: user.id)
    end
    
    private
    
        # Method that gets all articles that are available from subscriptions
        def get_subscription_articles user
            
            # Create an array to put each article in
            subscription_articles = Array.new
            
            # Loop over each subcription object
            user.subscriptions.each do |subscription|
                
                # Loop over each article from the subscription user in this loop
                user_articles(User.find_by(id: subscription[:id]), "all", (Time.now - 2.weeks)).each do |id, article|
                    
                    # Matt Clifford uses IFTT which regularly doesn't get an article.
                    if article["resolved_url"].include? "ifttt"
                        next
                    # If we can not find an element that has a url key with the same value as the articles url 
                    elsif subscription_articles.select{|element| element[:url] == article["resolved_url"]}.empty?
                        
                        # We need to push this article into our array with certain paramaters.
                        subscription_articles << {
                            url: article["resolved_url"], 
                            title: article["resolved_title"], 
                            excerpt: article["excerpt"], 
                            being_read_by: [subscription[:id]]
                        }
                    
                    # In the case where we do find a match, i.e the above is true
                    else
                        
                        # Get the index of the element where the url matches the article url
                        index = subscription_articles.index{|element| element[:url] == article["resolved_url"]}
                        
                        # Append the subscription user to the :being_read_by key of the hash
                        subscription_articles[index][:being_read_by] << subscription[:id]
                    end
                end
            end
            
            return subscription_articles
        end
        
        def find_recommendation_articles (user_articles, subscription_articles)
            
            # loop over subscription articles and check whether it is in user_articles (by resolved URL) if it is remove from subscription_articles
            user_articles_urls = Array.new
            
            user_articles.each do |id, article|
                user_articles_urls << article["resolved_url"]
            end
            
            # Loop over the subscription articles array
            subscription_articles.each do |article|
                # If this article's URL can be found in user_articles_urls then remove it from the subscription articles because we've already read it
                if !user_articles_urls.select{|url| url == article[:url]}.empty?
                    subscription_articles.delete(article)
                end
            end
            
            return subscription_articles
            
        end
        
        def build_recommendations (recommendation_articles)
            recommendation_articles.sort_by!{ |article| article[:being_read_by].count }.reverse
        end
        
end
