class SurgeriesController < ApplicationController
  # using the admin layout
  layout "admin"
  # before action need to  check the surgery   
  before_action :set_surgery, only: [:show, :edit, :update, :destroy]
  # Before action need to find the user type
  before_action :check_user
  # after need to check the user type 
  after_action :check_user_type,only: [:create,:update]

  # GET /surgeries
  # GET /surgeries.json
  def index
    # Initialize the surgery 
    @surgery = Surgery.new
    # adding the pagination for page with page limit 10 record
    @surgeries = Surgery.where(user_type: "admin").paginate(page: params[:page],per_page: 1)
  end

  # GET /surgeries/1
  # GET /surgeries/1.json
  def show
  end

  # GET /surgeries/new
  def new
    # Initilize the surgery page
    @surgery = Surgery.new
  end

  # GET /surgeries/1/edit
  def edit
  end

  # POST /surgeries
  # POST /surgeries.json
  def create
    # Initializing the surgery the params
    @surgery = devise_current_user.surgeries.new(surgery_params)
      # saving the surgery save after that redirect to the surgeries index page
      if @surgery.save
        redirect_to surgeries_path
      else
        # else redirect to the same page of the surgery
        redirect_to :back
      end
  end

  # PATCH/PUT /surgeries/1
  # PATCH/PUT /surgeries/1.json
  def update
      # Updating the particular surgery and after update redirecto toe surgries page
      if @surgery.update(surgery_params)
        redirect_to surgeries_path
      else
        # else redirect to the same page surgery
        redirect_to :back
      end
  end

  # DELETE /surgeries/1
  # DELETE /surgeries/1.json
  def destroy
    @surgery.destroy
    respond_to do |format|
      format.html { redirect_to surgeries_url, notice: 'Surgery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Method for search the surgery names
  def surgery_search
    # Search for the speciality names
    @surgeries = find_surgery_term(params[:surgeryterm])
    # respond to rendering the pages
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_surgery
      @surgery = Surgery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surgery_params
     params.require(:surgery).permit(:name)
    end

    # Method for search the surgery term
    def find_surgery_term surgeryterm
      # Search the surgery terms
      Surgery.where(user_type: "admin").any_of({ :name => /^#{surgeryterm}/i }) 
    end

  # Method for cheking the user type 
  def check_user_type
    # find the user 
    user = User.find(@surgery.user_id)
    # condition for checking the admin is present or not
    if user.admin == true
      # if admin then update the user type as admin
      @surgery.update(user_type: "admin")
    else
      # else user then update the user type as user
      @surgery.update(user_type: "user")
    end
  end
  
end
