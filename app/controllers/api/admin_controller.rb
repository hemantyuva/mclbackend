class Api::AdminController < Api::BaseController

  	skip_before_filter :verify_user,:has_passcode?

	# Before action need to find the user
	before_action :find_user,only: [:check_user]


	def check_user
		if @user.status == true
		# response to the JSON
			render json: { success: true, response: "User is enable"},:status=>200
	    else
	    	render :json=> { success: false, message: "User is disable." },:status=> 200
	    end
	end

	def show_form_template
		admin_forms = AdminForm.all
		if admin_forms.present?
	      render json: { success: true, response: admin_forms.map{ |f| AdminFormSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Form template are not present" },:status=> 203
	    end 
	end

	def show_form_field
		admin_fields = AdminField.all
		if admin_fields.present?
	      render json: { success: true, response: admin_fields.map{ |f| AdminFieldSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Form field are not present" },:status=> 203
	    end 
	end

 private

  	# Method for finding the particular user
	def find_user
		# Find the User 
		@user = User.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid User ID !'}, status: 400 if @user.nil?
	end

end
