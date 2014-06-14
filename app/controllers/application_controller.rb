class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.for(:sign_up) << :username
            devise_parameter_sanitizer.for(:sign_up) << :twitter_following
        end

    
    include PocketsHelper
    include UsersHelper
    
    def default_url_options
        if Rails.env.production?
            {:host => "http://www.pocket-social.com"}
        else  
            {}
        end
    end
end
