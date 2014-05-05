class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.for(:sign_up) << :username
        end
    
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include PocketsHelper
    include UsersHelper
    
    def default_url_options
        if Rails.env.production?
            {:host => "http://www.pocket-social.com"}
        else  
            {}
        end
    end
    
    private

        # Overwriting the sign_out redirect path method
        def after_sign_in_path_for(user)
            user_path(current_user)
        end
end
