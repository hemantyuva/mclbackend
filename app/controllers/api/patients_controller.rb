class Api::PatientsController <  Api::BaseController

  before_action :get_patient, only: [:show, :edit, :update, :destroy, :search_patients]
  respond_to :json

  # method for get all the patient
  def index
  	# get all patient of current user 
    @patients = current_user.patients
    if @patients.present?
      render json: { success: true, response: @patients.map{ |f| PatientSerializer.new(f).as_json( root: false ) } }
    else
      render :json=> { success: false, message: "Patients are not present" },:status=> 203
    end
  end

  # method for creating the patient
  def create
  	# creating the patient 
    @patient = current_user.patients.new(patient_params)
    if @patient.save
    	# response to the JSON
    	render json: { success: true,message: "Patient Successfully Created.", response: PatientSerializer.new(@patient).as_json(root: false) },:status=>200
    else
      render :json=> { success: false, message: @patient.errors },:status=> 203
    end
  end
  
  # method for updating the patient
  def update
  	# updating the patient
  	if @patient.update(patient_params)
  		# response to the JSON
			render json: { success: true,message: "Patient Successfully Updated.", response: PatientSerializer.new(@patient).as_json(root: false) },:status=>200
    	return
    else
      render :json=> { success: false, message: "Patient is not available" },:status=> 404
    	return
    end
  end

  # method for deleting the patient
  def destroy
  	#  destroy the particular patient
  	if @patient.destroy
  		# response to the JSON
  		render json: { success: true,message: "Patient Successfully Deleted."},:status=>200
    	return
    else
      render :json=> { success: false, message: "Patient is not available" },:status=> 404
    	return
    end
  end
  
  # method for searching the patient
  def show
  	# search the particular patient
  	if @patient.present?
  		# response to the JSON
    	render json: { success: true, response: @patient.as_json },:status=>200
      return
    else
      render :json=> { success: false, message: "Patient is not available" },:status=> 404
     return
    end
  end

  def search_patients
  	# search the particular patient
	  render json: { success: true, response: PatientSerializer.new(@patient).as_json(root: false) },:status=>200
	  return
  end

  private
    # Method for Permitting the attributes
  	
    # Find the paticular patient
  	def get_patient
      @patient = Patient.where( id: params[:id] || params[:patient_id])[0]
      if @patient.nil?
      	render :json=> { success: false, message: "Patient is not available" },:status=> 404
      	return
      end
    end

    # Permitting the patient attributes 
    def patient_params
      params.require(:patient).permit(:firstname, :phone, :lastname , :email , :dob , :gender)
    end

end
