 class CasesController < ApplicationController
	# before action need find the case
	before_action :find_case,only: [:show,:edit,:destroy,:new_case_template,:edit_case_surgery]
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user

	# Method for creating the cases
	def create
		params[:case][:owner_id] = devise_current_user.id.to_s
		# creating the cases with particular surgeon
		surgery_case = current_user.cases.create(case_params)
		if params[:user_form_id].present?
	 		user_form = UserForm.find(params[:user_form_id]) 
	 		surgery_case.user_form = user_form
	 		surgery_case.user_form_fields = user_form.form_fields.to_a
	 	end
	 	surgery_case.user_form_data = params[:fields]
 		surgery_case.save
 		if params[:no_button]=="true"
			redirect_to schedules_path
		else
			# redirect to the case index page
			redirect_to edit_case_surgery_case_path(surgery_case)	
		end
	end

	# Method for get the all the case details
	def index
	    # get the current surgeon of the all case details
	    @cases = current_user.cases.order_by(:surgery_date=> :asc).collect{|surgery_case| surgery_case if (surgery_case.surgery_date.to_date.past? || surgery_case.surgery_date.to_date.today?)}.reject(&:blank?).take(10)
	end

	# Method for showing paticular case details
	def show
	end 

	# Method for edit the case surgery form
	def edit_case_surgery
		@form = UserForm.find(@case.user_form_id) if @case.user_form_id.present?
	end


	# Method for the edit the case form
	def edit
		# Get the schedule details with case
		@schedule = @case.schedule
		# Initialize surgery location form
		@setting = current_user.setting.blank? ? current_user.build_setting : current_user.setting
		# Find the patient for the particular case
		@patient = Patient.find(@case.patient_id)
		@schedule_active = true
	end
	
	# Method for updating the cases
	def update
		params[:case][:owner_id] = devise_current_user.id.to_s
		# Method for find the case
		surgery_case = current_user.cases.find(params[:id])
		# Update the surgery case attributes
		surgery_case.update_attributes(case_params)
		#redirect to the case index page
		# user_form = user_form_and_fields(params[:admin_form_id]) if params[:my_template]=="false"
		# user_form = user_own_form_and_fields(params[:admin_form_id]) if params[:my_template]=="true"
	 	surgery_case.user_form_data = params[:fields]
 		surgery_case.save
		if params[:edit_surgery]=="true"
			redirect_to case_path(surgery_case)
		else
			redirect_to schedules_path
		end
	end

	# Method for destroy the particular case details
	def destroy
		# destroy the particular case
		@case.destroy
		# redirect to the cases index page(same page)
		redirect_to :back
	end

	def new_case_template
		@form = AdminForm.find(params[:case_from_id])
		respond_to do |format|
			format.html do
				render "new_case_template", layout: false
			end
		end
	end

	def new_user_case_template
		@form = UserForm.find(params[:case_from_id])
		respond_to do |format|
			format.html do
				render "new_user_case_template", layout: false
			end
		end
	end

	private

	# Creating my own case templates from admin templates
	def user_form_and_fields(admin_form_id)
		case_form_template = AdminForm.find(admin_form_id)
		fields = []
		
		case_form_template.form_fields.each do |field_id|
			admin_field = AdminField.find(field_id)
			field = current_user.user_fields.find_or_initialize_by(field_name: admin_field.field_name,field_slug:admin_field.field_slug,field_type: admin_field.field_type)
			if admin_field.field_type == 'select' || admin_field.field_type == 'radio'
				field.field_options = admin_field.field_options
			end
			field.save
			fields << field.id.to_s
		end

		i=0
		form_field_count = 1
		while i <= current_user.user_forms.count  do
		   form_name = "#{case_form_template.form_name}-#{i}"
		   if !current_user.user_forms.where(:form_name => form_name).blank?
		    form_field_count += 1
		   end
		   i +=1
		end
		
		form = current_user.user_forms.find_or_initialize_by(form_name: "#{case_form_template.form_name}-#{form_field_count}",form_name_slug:case_form_template.form_name_slug, form_fields:fields)
		form.form_fields=form.form_fields.to_a+params[:case_user_fields_ids].to_a
		form.save
		return form
	end

	# Updating own case templates
	def user_own_form_and_fields(user_form_id)
		form = UserForm.find(user_form_id)
		form.form_fields=form.form_fields.to_a+params[:case_user_fields_ids].to_a
		form.save
		return form
	end

	# Method for Permitting the attributes
	def case_params
		# Permitting the case attributes with nested form schedule attributes
		params.require(:case).permit(:diagnose_name,:surgery_name,:surgery_date,:patient_id,:side,:owner_id,schedule_attributes: [:schedule_date,:surgery_location_id],assistant_name: [])
	end

	# Methos for finding the particular case
	def find_case
	  	# Finding the particular case
	 	@case = Case.find(params[:id])
	end
end