class Patients::CasesController < ApplicationController
	# Before action need to find the user type
  	before_action :check_admin
  	# before action need to check the session time out
  	before_action :check_max_session_time
  	# before action need to check the user is existed or not
  	before_action :find_logged_user

	# Initialize the patient case new form
	def new
		# Initialize case new form
		@case = Case.new
		# Initialize schedule from with case
		@schedule = @case.build_schedule
		# find the patient id for the particular case
		@patient = Patient.find(params[:patient_id])
	end
	
end