class UserFormsController < ApplicationController
	# Before action need to find the user type
  	before_action :check_admin
  	# before action need to check the session time out
  	before_action :check_max_session_time
  	# before action need to check the user is existed or not
  	before_action :find_logged_user
  	# before action need to find the particular form
  	before_action :set_user_form, only:[:edit,:update]

  	def index
  		@user_forms = current_user.user_forms
  	end

  	def new_field
		@user_field = UserField.new
		respond_to do |format|
		  format.js
		end
	end

	def new_user_form
		@admin_form = AdminForm.find(params[:surgary_form_id]) if params[:surgary_form_id].present?
		@admin_form = AdminForm.find(params[:followup_form_id]) if params[:followup_form_id].present?
		@admin_form = AdminForm.find(params[:form_id]) if params[:form_id].present?
	end

	def create_user_form
		if user_form_and_fields(params[:form_id])
			redirect_to user_forms_path
		else
			redirect_to new_user_form_user_forms_path(form_id: params[:form_id])
			flash[:notice] = "Form name already exists"
		end
	end

	def edit
		
	end

	def update
		@user_form.update_attributes(user_form_params)
		redirect_to user_forms_path
	end

	def create_field
		# Creating the user field
    	@field = current_user.user_fields.new(user_field_params)
    	#save the user field
    	@field.save
    	respond_to do |format|
		  format.js
		end
	end

	private

	# Creating my own case templates from admin templates
	def user_form_and_fields(admin_form_id)
		case_form_template = AdminForm.find(admin_form_id)
		admin_fields = params[:admin_form][:form_fields]
		fields = []
		
		admin_fields.each do |field_id|
			admin_field = AdminField.find(field_id)
			field = current_user.user_fields.find_or_initialize_by(field_name: admin_field.field_name,field_slug:admin_field.field_slug,field_type: admin_field.field_type,required:admin_field.required, multiple: admin_field.multiple )
			if admin_field.field_type == 'select' || admin_field.field_type == 'radio'
				field.field_options = admin_field.field_options
			end
			field.save
			fields << field.id.to_s
		end

		form = current_user.user_forms.build(form_type:case_form_template.form_type,form_name: params[:admin_form][:form_name],form_name_slug:params[:admin_form][:form_name_slug], form_fields:fields)
		form.form_fields=form.form_fields.to_a + (params[:user_form][:form_fields].to_a rescue [])
		return form.save
	end

	def set_user_form
		@user_form = UserForm.find(params[:id])
	end

 	def user_form_params
		params.require(:user_form).permit(:form_name, :form_name_slug,form_fields: [])
	end

	def user_field_params
		params.require(:user_field).permit(:field_name, :field_slug,:field_type,:required,:multiple, field_options_attributes: [:id, :option_text,:default_option,:_destroy])
	end

end
