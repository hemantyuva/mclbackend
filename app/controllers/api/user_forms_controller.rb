class Api::UserFormsController < Api::BaseController
 
  	def create_field
		# Creating the user field
    	field = current_user.user_fields.new(user_field_params)
    	#save the user field
    	if field.save
    	# response to the JSON
    	   render json: { success: true,message: "User Form Successfully Created.", response: UserFormSerializer.new(field).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: field.errors },:status=> 203
	    end
	end

	private

	def user_field_params
		params.require(:user_field).permit(:field_name, :field_slug,:field_type,:required,:multiple, field_options_attributes: [:id, :option_text,:default_option,:_destroy])
	end

end
