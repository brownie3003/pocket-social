class UserMailer < ActionMailer::Base
    add_template_helper(ArticlesHelper)
    default from: "team@pocket-social.com"
    
    def recommendations_email user

        @user = user
        
        # Build recommendations 
        if user.subscriptions.any?
            recommendations = user.article_feed
        else
            recommendations = []
        end
        
        @recommendations = order_by_popularity(recommendations)

        mail(to: user.email , subject: "Weekly article recommendations from Pocket-Social", bcc: "brownie3003@gmail.com")
    end
end
