module CasesHelper

	# def update_user_form_fields
	# 	fields = []
	# 	params[:fields].map do |field_name, value|
	# 		admin_field = AdminField.find_by(field_name: field_name) rescue false
	# 		if admin_field
	# 			name = admin_field[:field_name]
	# 			type = admin_field[:field_type]
	# 			@field = UserField.where(field_name: name,field_type: type).first_or_initialize
	# 		else
	# 			@field = UserField.where(field_name: field_name).first_or_initialize
	# 		end
	# 		@field.save
	# 		fields << @field.id.to_s
	# 	end
	# 	@form.update(form_fields:fields)
	# end

end
