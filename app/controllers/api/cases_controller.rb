class Api::CasesController <  Api::BaseController
	# Before action find the patient id
	before_action :find_patient, only: [:show,:edit,:destroy,:create,:update]
	# Before action find the case id
	before_action :find_case,only: [:show,:edit,:destroy]

	respond_to :json

	# Method for get the all the case details
	def index
		# get the current surgeon of the all case details
		cases = current_user.cases.order_by(:schedule_date=> :asc).collect{|surgery_case| surgery_case if (surgery_case.schedule.schedule_date.to_date.past? || surgery_case.schedule.schedule_date.to_date.today?)}.reject(&:blank?).take(10)
		if cases.present?
	      render json: { success: true, response: cases.map{ |f| CaseSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Cases are not present" },:status=> 203
	    end 
	end

	# Method for creating the cases
	def create
		# creating the cases with particular surgeon
		surgery_case = current_user.cases.create(case_params)
		# Updating the patient to the particular case
		surgery_case.update_attributes(patient_id: params[:patient_id])
		# redirect to the case index page
		if surgery_case.present?
    	# response to the JSON
	    	render json: { success: true,message: "Case Successfully Created.", response: CaseSerializer.new(surgery_case).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: surgery_case.errors },:status=> 203
	    end
	end

	# Method for showing paticular case details
	def show
		if @case.present?
  		# response to the JSON
    	render json: { success: true, response: @case.as_json("case_show") },:status=>200
	      return
	    else
	      render :json=> { success: false, message: "Case is not available" },:status=> 404
	     return
	    end  
	end	
	
	# Method for updating the cases
	def update
		surgery_case = current_user.cases.where( id: params[:id] )[0]
		if surgery_case.present?
			surgery_case.update_attributes(case_params)
			# Updating the patient to the particular case
			surgery_case.update_attributes(patient_id: params[:patient_id])
  		# response to the JSON
			render json: { success: true,message: "Case Successfully Updated.", response: surgery_case.as_json("case_show") },:status=>200
	    else
	      render :json=> { success: false, message: "Case is not available" },:status=> 404
	    end
	end

	# Method for updating the cases
	# def update
	# 	# Method for find the case
	# 	surgery_case = current_user.cases.find(params[:id])
	# 	# Update the surgery case attributes
	# 	surgery_case.update_attributes(case_params)
	# 	#redirect to the case index page
	# 	user_form = user_form_and_fields(params[:admin_form_id]) if params[:my_template]=="false"
	# 	user_form = user_own_form_and_fields(params[:admin_form_id]) if params[:my_template]=="true"
 # 		surgery_case.user_form = user_form
 # 		surgery_case.user_form_data = params[:fields]
 # 		if surgery_case.save
 # 		# response to the JSON
	# 		render json: { success: true,message: "Case Successfully Updated.", response: CaseSerializer.new(surgery_case).as_json(root: false) },:status=>200
	#     else
	#       render :json=> { success: false, message: "Case is not available" },:status=> 404
	#     end
	# end

	# Method for destroy the particular case details
	def destroy
		# destroy the particular case
		if @case.destroy
  		# response to the JSON
  		render json: { success: true,message: "Case Successfully Deleted."},:status=>200
    	return
	    else
	      render :json=> { success: false, message: "Case is not available" },:status=> 404
	    	return
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
			params.require(:case).permit(:diagnose_name,:surgery_name,:side,assistant_name: [],schedule_attributes: [:schedule_date,:surgery_location])
		end

		# Methos for finding the particular case
		def find_case
			# Finding the particular case
			@case = Case.where( id: params[:id])[0]
			if @case.nil?
	      render :json=> { success: false, message: "Case is not available" },:status=> 404
	      return
	    end
		end

		def find_patient
			patient = Patient.where(:id => params[:patient_id])[0]
			if patient.nil?
				render :json=> { success: false, message: "Patient is not available" },:status=> 404
	      return
	    end
		end
end