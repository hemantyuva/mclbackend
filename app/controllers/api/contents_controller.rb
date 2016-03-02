class Api::ContentsController < Api::BaseController
	skip_before_filter :verify_user,:has_passcode?

    #method for about content 
	def about
		content = Content.new(about_content: params[:content])
		if content.save
		# response to the JSON
			render json: { success: true,message: "About Content Successfully Created.", response: content.as_json("about") },:status=>200
		else
		  render :json=> { success: false, message: content.errors },:status=> 203
		end
	end

	#method for faq content 
	def faq
		content = Content.new(faq_content: params[:content])
		if content.save
		# response to the JSON
			render json: { success: true,message: "Faq Content Successfully Created.", response: content.as_json("faq") },:status=>200
		else
		  render :json=> { success: false, message: content.errors },:status=> 203
		end
	end

	#method for contact content 
	def contact
		content = Content.new(contact_address: params[:address],contact_number: params[:contact_number],email: params[:email])
		if content.save
		# response to the JSON
			render json: { success: true,message: "Contact Content Successfully Created.", response: content.as_json("contact") },:status=>200
		else
		  render :json=> { success: false, message: content.errors },:status=> 203
		end
	end

end
