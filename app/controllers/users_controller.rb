class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:edit, :update]
    before_action :correct_user, only: [:edit, :update]
    after_filter :store_location
    
    # GET /users
    # GET /users.json
    def index
        @users = User.all.paginate(per_page: 10, page: params[:page])
    end
    
    # GET /users/1
    # GET /users/1.json
    def show
        if @user.pocket
            # Currently only getting 2 weeks worth of articles, prevents heavy users of pocket slowing down load.
            @articles = user_articles(@user, "all", (Time.now - 2.weeks))
            if @user != current_user
                if current_user
                    @current_user_articles = user_articles(current_user, "all")
                    @current_user_article_urls = Array.new
                    @current_user_articles.each do |id, article|
                        @current_user_article_urls << article["resolved_url"]
                    end
                end
            end
        end
    end
    
    # GET /users/new
    def new
        @user = User.new
    end
    
    # GET /users/1/edit
    def edit
        
    end
    
    # POST /users
    # POST /users.json
    def create
        
    end
    
    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
        respond_to do |format|
            if @user.update_attributes(user_params)
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url }
            format.json { head :no_content }
        end
    end
    
    def subscribe
        if current_user.nil?
            redirect_to new_user_registration_path, notice: "Hey new user, you've got to sign up before we can let you see what's in people's pockets."
        elsif current_user.pocket.nil?
            redirect_to :back, notice: "Whoa there buddy, before you can go rootlin' around in other poeple's pockets, you've got to link your pocket (psst... just above me is the link)"
        else
            current_user.subscribe!(User.find(params[:subscribe_to_user]))
            redirect_to User.find(params[:subscribe_to_user])
        end
    end
    
    def unsubscribe
        current_user.unsubscribe!(User.find(params[:unsubscribe_to_user]))
        redirect_to User.find(params[:unsubscribe_to_user])
    end
    
    def add_article
        add_article_helper params[:article], current_user.pocket.access_token
        redirect_to User.find(params[:user])
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
            @user = User.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
            params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end
        
        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_url) unless current_user == @user
        end

        def store_location
        # store last url - this is needed for post-login redirect to whatever the user last visited.
            if (request.fullpath != "/users/sign_in" &&
                request.fullpath != "/users/sign_up" &&
                request.fullpath != "/users/password" &&
                request.fullpath != "/users/sign_out" &&
                !request.xhr?) # don't store ajax calls
                session[:previous_url] = request.fullpath 
            end
        end
        
        def after_sign_in_path_for(user)
            session[:previous_url] || user_path(current_user)
        end
end
