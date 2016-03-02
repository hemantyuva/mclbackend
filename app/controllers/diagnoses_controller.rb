class DiagnosesController < ApplicationController
  # using the admin layout
  layout "admin"
  # before action need to find the diagnose
  before_action :set_diagnosis, only: [:show, :edit, :update, :destroy]
  # Before action need to find the user type
  before_action :check_user
  # after need to check the user type 
  after_action :check_user_type,only: [:create,:update]

  # GET /diagnoses
  # GET /diagnoses.json
  def index
    @diagnoses = Diagnose.where(user_type: "admin").paginate(page: params[:page],per_page: 10) 
    @diagnosis = Diagnose.new
  end

  # GET /diagnoses/1
  # GET /diagnoses/1.json
  def show
  end

  # GET /diagnoses/new
  def new
    @diagnosis = Diagnose.new
  end

  # GET /diagnoses/1/edit
  def edit
  end

  # POST /diagnoses
  # POST /diagnoses.json
  def create
    # Initialize the Diagnose attributes
    @diagnosis = devise_current_user.diagnose.new(diagnosis_params)
      # After Initializing the diagnose need to save the attributes
      if @diagnosis.save
        # redirect ot the diagnose list page
        redirect_to diagnoses_path
      else
        # redirect to the same page
        redirect_to :back
      end
  end

  # PATCH/PUT /diagnoses/1
  # PATCH/PUT /diagnoses/1.json
  def update
      # Find the particular diagnose and update the attributes
      if @diagnosis.update(diagnosis_params)
        # redirect to the diagnose index page
        redirect_to diagnoses_path
      else
        # redirect to the same of the diagnose
        redirect_to :back
      end
  end

  # DELETE /diagnoses/1
  # DELETE /diagnoses/1.json
  def destroy
    @diagnosis.destroy
    respond_to do |format|
      format.html { redirect_to diagnoses_url, notice: 'Diagnose was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def diagnose_search
    # Search for the speciality names
    @diagnoses = find_diagnose_term(params[:diagnoseterm])
    # respond to rendering the pages
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diagnosis
      @diagnosis = Diagnose.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diagnosis_params
      params.require(:diagnose).permit(:name)
    end

    # Method for finding the particular keyword from name or mobile
    def find_diagnose_term diagnoseterm
      Diagnose.where(user_type: "admin").any_of({ :name => /^#{diagnoseterm}/i }) 
    end

 # Method for cheking the user type 
  def check_user_type
    # find the user 
    user = User.find(@diagnosis.user_id)
    # condition for checking the admin is present or not
    if user.admin == true
      # if admin then update the user type as admin
      @diagnosis.update(user_type: "admin")
    else
      # else user then update the user type as user
      @diagnosis.update(user_type: "user")
    end
  end

end
