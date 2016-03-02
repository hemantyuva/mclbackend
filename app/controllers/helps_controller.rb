class HelpsController < ApplicationController
  layout "admin"
  before_action :set_help, only: [:show, :edit, :update, :destroy]
  # before action need to check the content is created or not
  before_action :content_check,only: [:index]

  # GET /helps
  # GET /helps.json
  def index
    @help = Help.new
    @helps = Help.all
  end

  # GET /helps/1
  # GET /helps/1.json
  def show
  end

  # GET /helps/new
  def new
    @help = Help.new
  end

  # GET /helps/1/edit
  def edit
  end

  # POST /helps
  # POST /helps.json
  def create
    # Intialize the help add video params
    @help = Help.new(help_params)
    # After Initialize the help save the help
      if @help.save
        # After saving the the help then navigating to the  helps
        redirect_to helps_path
      else
        # If help is not save then navigate to the navigating the same page
        redirect_to :back
      end
  end

  # PATCH/PUT /helps/1
  # PATCH/PUT /helps/1.json
  def update
      # Update the help parameters
      if @help.update(help_params)
        # After saving the the help then navigating to the  helps
        redirect_to helps_path
      else
      # If help is not save then navigate to the navigating the same page
       redirect_to :back
      end
  end

  # DELETE /helps/1
  # DELETE /helps/1.json
  def destroy
    @help.destroy
    respond_to do |format|
      format.html { redirect_to helps_url, notice: 'Help was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help
      @help = Help.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_params
     params.require(:help).permit(:title,:url)
    end

    def content_check
			if Content.first.present?
				id = Content.first.id
				@content = Content.find(id)
			else
				@content = Content.new
			end
    end
end
