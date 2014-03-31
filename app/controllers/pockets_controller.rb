class PocketsController < ApplicationController
  before_action :set_pocket, only: [:show, :edit, :update, :destroy]

  # GET /pockets
  # GET /pockets.json
  def index
    @pockets = Pocket.all
  end

  # GET /pockets/1
  # GET /pockets/1.json
  def show
  end

  # GET /pockets/new
  def new
    @pocket = Pocket.new
  end

  # GET /pockets/1/edit
  def edit
  end

  # POST /pockets
  # POST /pockets.json
  def create
    @pocket = Pocket.new(pocket_params)

    respond_to do |format|
      if @pocket.save
        format.html { redirect_to @pocket, notice: 'Pocket was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pocket }
      else
        format.html { render action: 'new' }
        format.json { render json: @pocket.errors, status: :unprocessable_entity }
      end
    end
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
