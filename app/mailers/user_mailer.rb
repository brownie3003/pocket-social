class UserMailer < ActionMailer::Base
    add_template_helper(UsersHelper)
    default from: "team@pocket-social.com"
    
    def recommendations_email user

        @user = user
        
        # Check user has pocket and subscriptions, should change because people don't have to have pocket associated
        if !user.pocket.nil? && !user.subscriptions.empty?
            @recommendations = order_by_popularity(article_feed(user))
        end
        
        mail(to: user.email , subject: "Weekly article recommendations from Pocket-Social", bcc: "brownie3003@gmail.com")
    end
end
