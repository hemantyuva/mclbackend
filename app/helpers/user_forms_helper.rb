module UserFormsHelper
	def default_dropdown_value(form_value)
		if form_value.blank?
			@field.field_options.where(default_option: true).present? ? @field.field_options.where(default_option: true).first.id : ""
		else
			form_value
		end
	end

	def default_radio_option(form_value, option)
		if form_value.blank?
			option.default_option
		else
			form_value==option.option_text
		end
	end

	def default_checkbox_option(form_value, option)
		if form_value.blank?
			option.default_option
		else
			form_value.include?(option.option_text)
		end
	end
end

