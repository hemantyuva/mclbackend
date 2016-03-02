class SchedulesController < ApplicationController
	  # before action need to check the schedle list method
	  before_action :case_list,only: [:index,:schedule_view,:list_view]
	  # Before action need to find the user type
  	before_action :check_admin
 	  # before action need to check the session time out
  	before_action :check_max_session_time
  	# before action need to check the user is existed or not
  	before_action :find_logged_user

	# Method for add schedule page
	def add
	end	
	
	# Method for creating the schedule with patient,surgery and surgerylocation
	def create
		schedule = current_user.schedules.create(schedule_params)
		# updating the patient_id after scheduled created
		schedule.update_attributes(patient_id: params[:patient_id]) if !params[:patient_id].nil?
		# after schedule creation redirect to the schedules index page 
		redirect_to schedules_path
	end

	# Method for list out all the surgery created by surgeon 
	def index
	end

	# Method for changin the view of the schedules
	def schedule_view
		# render the partial page with js to show the schedule view
		respond_to do |format|
			format.js
		end
	end

	# Method for changin the view of the schedules
	def list_view
		# render the partial page with js to show the list view
		respond_to do |format|
			format.js
		end
	end

	# Searching patients using ajax and showing on autocomplete
	def search_patients
		# Searching for patients as per user entered term
		patients = current_user.patients.search_by_name(params[:term]).collect{|patient| {label:  patient_search_meta(patient),name: "#{patient.firstname} #{patient.lastname}",value: patient.id.to_s}  }.to_json
		respond_to do |format|
		  format.json { render :json => patients }
		end
	end	

	# Method for searching the diagnose name according to the diagnose terms
	def search_diagnose
		# Searching for diagnose as per user entered term
		if Diagnose.where(user_type: "admin").any_of({ :name => /^#{params[:term]}/i }).present?
			# if search show from the admin then the search term from diagnose of admin
			diagnose = Diagnose.where(user_type: "admin").any_of({ :name => /^#{params[:term]}/i }).all.collect{|diagnosis|  {label: diagnosis.name}}.uniq.to_json
		else
			# else the term is not equal to the admin diagnose then that search from the user term
			diagnose = current_user.diagnose.any_of({ :name => /^#{params[:term]}/i }).all.collect{|diagnosis|  {label: diagnosis.name}}.uniq.to_json 
		end
		# render to the diagnose name page
		respond_to do |format|
		  format.json { render :json => diagnose }
		end
	end

	# Method for searching the surgery name according to the surgery names terms
	def search_surgery
		# Searching for surgery as per user entered term
		if Surgery.where(user_type: "admin").any_of({ :name => /^#{params[:term]}/i }).present?
			# if search show from the admin then the search term from surgery of admin
			surgeries = Surgery.where(user_type: "admin").any_of({ :name => /^#{params[:term]}/i }).all.collect{|surgery|  {label: surgery.name}}.uniq.to_json
		else
			# else the term is not equal to the admin surgery then that search from the user term
			surgeries = current_user.surgeries.any_of({ :name => /^#{params[:term]}/i }).all.collect{|surgery|  {label: surgery.name}}.uniq.to_json 
		end
		# render to the surgery name page
		respond_to do |format|
		  format.json { render :json => surgeries }
		end
	end

private
	# Permitting the schedule attributes
	def schedule_params
		params.require(:schedule).permit(:schedule_date,:diagnose,:surgery_location_id,:surgery)
	end

	# patient template for the autocomplete
	def patient_search_meta(patient)
		"<span style='float:left;margin-right:10px;'><img src='#{patient.icon}'/></span> <span data-name='#{patient.firstname} #{patient.lastname}'><b>#{patient.firstname}</b> #{patient.lastname}</span> <span style='float:right;'>#{patient.dob.to_natural}</span>"
	end

	# Method for the showing the all schedules
	def case_list
		# listing the all the schedule cases with surgeon with ascending schedule date
		@cases = current_user.cases.order_by(:schedule_date=> :asc)
	end
end


