class AdminFormsController < ApplicationController
	# Calling the Admin layout for all the methods
	layout "admin"
	# Before action need to find the user type
	before_action :check_user
	# Before action need to find the admin field id
	before_action :set_admin_field, only: [:edit_field, :update_field, :destroy_field]
	# Before action need to find the admin form id
	before_action :set_admin_form, only: [:edit_form, :update_form, :destroy_form]
	
	def index
		@tab = params[:tab]
		@admin_fields = AdminField.all
		@admin_forms = AdminForm.all
	end

	def new_field
		@admin_field = AdminField.new
	end
	
	def create_field
		# Creating the admin field
    	admin_field = AdminField.new(admin_field_params)
    	#save the admin field
    	admin_field.save
    	# redirect to the admin form index page
    	redirect_to admin_forms_path(tab:"case_field")
	end

	def edit_field
		
	end

	def update_field
		if @admin_field.field_options.present?
			@admin_field.field_options.each do |option|
				option.default_option = false
				option.save
			end
		end
		@admin_field.update_attributes(admin_field_params)
		if params[:admin_field][:field_type] == 'text' || params[:admin_field][:field_type] == 'textarea' || params[:admin_field][:field_type] == 'date'|| params[:admin_field][:field_type] == 'number' ||  params[:admin_field][:field_type] == 'time'
			@admin_field.field_options.destroy_all
		end
		redirect_to admin_forms_path(tab:"case_field")
	end

	def destroy_field
		@admin_field.destroy
		redirect_to admin_forms_path(tab:"case_field")
	end

	def new_form
		@admin_form = AdminForm.new
		@admin_fields = AdminField.all
	end
	
	def create_form
		# Creating the patient with present surgeon
    	form = AdminForm.new(admin_form_params)
    	#save the admin fields
    	form.save
    	# redirect to the admin form index page
    	redirect_to admin_forms_path
	end

	def edit_form
		@admin_fields = AdminField.all
	end

	def update_form
		@admin_form.update_attributes(admin_form_params)
		redirect_to admin_forms_path
	end

	def destroy_form
		@admin_form.destroy
		redirect_to admin_forms_path
	end

	private

	def set_admin_field
		@admin_field = AdminField.find(params[:id])
	end

	def set_admin_form
		@admin_form = AdminForm.find(params[:id])
	end

	def admin_field_params
		params.require(:admin_field).permit(:field_name, :field_slug,:field_type,:required,:multiple,field_options_attributes: [:id, :option_text,:default_option,:_destroy])
	end

	def admin_form_params
		params.require(:admin_form).permit(:form_type,:form_name, :form_name_slug,form_fields: [])
	end

  	def check_user
	    unless current_user.admin?
	      redirect_to root_url
	    end
  	end
end
