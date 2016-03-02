class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy,:case_listing]
  load_and_authorize_resource  param_method: :patient_params, except: :index
  # before action need to find the all cases list
  before_action :case_listing,only: [:show]
  # Before action need to find the user type
  before_action :check_admin
  # before action need to check the session time out
  before_action :check_max_session_time
  # before action need to check the user is existed or not
  before_action :find_logged_user

  # GET /patients
  # GET /patients.json
  def index
    if !user_signed_in?
      redirect_to new_user_session_url 
    else 
      @patients = Patient.where(:user_id => current_user.id).paginate(page: params[:page],per_page: 20)
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  # Method for the creating the patients
  def create
    # Creating the patient with present surgeon
    params[:patient][:owner_id] = devise_current_user.id.to_s
    patient = current_user.patients.new(patient_params)
    # Condition for checking the saved or not
    if patient.save
      # Check the condition of which url is present
      if params[:patient][:prev_url].present?
      # If prev present then navigate to the patients case form
        redirect_to new_patient_case_path(patient)
      else
      # redirect to the patients if prev url not present
        redirect_to patients_path
      end
    else
      # redirect to the same page of the patient new page
      redirect_to :back
      # if the record is not save then navigate to the same page and showing the flash
      flash.notice = "Need fill out the Essential Fields"
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      params[:patient][:owner_id] = devise_current_user.id.to_s 
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:firstname, :phone, :lastname , :email , :dob , :gender, :owner_id)
    end

    # Method for find list of the all the cases
    def case_listing
      @cases = @patient.cases.all.order('created_at ASC')
    end
end
