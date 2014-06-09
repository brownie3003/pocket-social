class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
        # Search DB with provider: "twitter" and the uid from twitter
        omniauth_hash = request.env["omniauth.auth"]
        user = User.from_omniauth(omniauth_hash)
        # If user is already signed in, therefore associating their account with twitter
        if user_signed_in?
            current_user.update_attributes(
                provider: omniauth_hash["provider"],
                uid: omniauth_hash["uid"]
            )
            redirect_to root_path
        # If we find the user in the DB
        elsif user.persisted?
            flash.notice = "Signed in"
            sign_in_and_redirect user
        # Else create a new user passing in the info we can get from the omniauth callback (e.g. Nickname from twitter)
        else
            session["devise.user_attributes"] = user.attributes
            puts session["devise.user_attributes"]
            redirect_to new_user_registration_url
        end
    end

    alias_method :twitter, :all
end
