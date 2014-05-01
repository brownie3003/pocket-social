class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            sign_in user
            if !current_user.nil?
                redirect_back_or user
            else
                flash.now[:error] = "Site error we couldn't sign you in"
                render 'new'
        else
            flash.now[:error] = 'Invalid email/password combination'
            render 'new'
        end 
    end

    def destroy
        sign_out
        redirect_to root_path
    end
end
