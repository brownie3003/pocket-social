class PocketsController < ApplicationController
    before_action :set_pocket, only: [:update, :destroy]
    # signed_in_user in Sessions_helper (made available to all controllers as included in Application Controller)
    before_action :authenticate_user!
    
    def new
        # Connect to Pocket and get username + token.
        request_pocket
    end
    
    def pocket_auth
        puts session[:code]
    end
        
    # POST /pockets
    def create
        response = create_pocket

        current_user.create_pocket(access_token: response["access_token"], username: response["username"])
        
        redirect_to current_user, notice: "Pocket was successfully linked to your account."
    end

    # PATCH/PUT /pockets/1
    # PATCH/PUT /pockets/1.json
    def update
        respond_to do |format|
            if @pocket.update(pocket_params)
                format.html { redirect_to @pocket, notice: 'Pocket was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @pocket.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /pockets/1
    # DELETE /pockets/1.json
    def destroy
        @pocket.destroy
        respond_to do |format|
            format.html { redirect_to pockets_url }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_pocket
            @pocket = Pocket.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def pocket_params
            params.require(:pocket).permit(:username, :token)
        end
end
