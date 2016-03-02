class SpecialitiesController < ApplicationController
  # using the admin layout
  layout "admin"
  # before action need to find the speciality
  before_action :set_speciality, only: [:show, :edit, :update, :destroy]
  # Before action need to find the user type
  before_action :check_user

  # GET /specialities
  # GET /specialities.json
  def index
    @speciality = Speciality.new
    @specialities = Speciality.paginate(page: params[:page],per_page: 10)
  end

  # GET /specialities/1
  # GET /specialities/1.json
  def show
  end

  # GET /specialities/new
  def new
    @speciality = Speciality.new
    @speciality.created_at = DateTime.now ;
    
  end

  # GET /specialities/1/edit
  def edit
  end

  # POST /specialities
  # POST /specialities.json
  def create
    # Initialize the speciality params
    @speciality = Speciality.new(speciality_params)
      # if speciality is save then navigate to the specialities index page
      if @speciality.save
        redirect_to specialities_path
      else
        # else redirect to the same page of the speciality
        redirect_to :back
      end
  end

  # PATCH/PUT /specialities/1
  # PATCH/PUT /specialities/1.json
  def update
      # Updating the specialityy of the particular speciality
      if @speciality.update(speciality_params)
        # If speciality is update then navigate to the specialities path
        redirect_to specialities_path
      else
        # else redirect to the same page of the speciality
        redirect_to :back
      end
  end

  # DELETE /specialities/1
  # DELETE /specialities/1.json
  def destroy
    @speciality.destroy
    respond_to do |format|
      format.html { redirect_to specialities_url, notice: 'Speciality was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def specialist_search
    # Search for the speciality names
    @specialities = find_speciality_term(params[:specialityterm])
    # respond to rendering the pages
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speciality
      @speciality = Speciality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speciality_params
      params.require(:speciality).permit(:name)
    end

  # Method for finding the particular keyword from name or mobile
    def find_speciality_term specialityterm
      Speciality.any_of({ :name => /^#{specialityterm}/i }) 
    end

end
