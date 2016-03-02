class Api::SettingsController < Api::BaseController
	
	# Method for checking the session time
	def set_session_time
		if current_user.setting.update(session_max: params[:time_limit])
		# response to the JSON
		  render json: { success: true,message: "Session Successfully Updated."},:status=>200
	    else
	      render :json=> { success: false, message: current_user.errors },:status=> 203
	    end
	end

	# Method for set the limit for the media upload
	def set_media_upload_limit
		# Creating the limitation for the question tags
		media_upload_limit = setting.build_media_upload(media_upload_limit: params[:media_upload_limit])
		# creating the question tags limit
		if media_upload_limit.save
		# response to the JSON
		  render json: { success: true,message: "Media Upload limit Successfully Updated.",response: {media_upload_limit: media_upload_limit.media_upload_limit.as_json }},:status=>200
	    else
	      render :json=> { success: false, message: media_upload_limit.errors },:status=> 203
	    end	
	end

	# Method for creating ther media tag for setting the limit
	def set_media_tag
		# Creating the limitation for the media attachment tags
		media_tag_limit = setting.build_media_tag(media_tag_limit: params[:media_tag_limit])
		# creating the media tags limit
		if media_tag_limit.save
		# response to the JSON
		  render json: { success: true,message: "Media Tag limit Successfully Updated.",response: {media_tag_limit: media_tag_limit.media_tag_limit.as_json }},:status=>200
	    else
	      render :json=> { success: false, message: media_tag_limit.errors },:status=> 203
	    end	
	end

	# Method for creating ther question tag for setting the limit
	def set_scn_tag
		# Creating the limitation for the question tags
		scn_tag_limit = setting.build_scn_tag(scn_tag_limit: params[:scn_tag_limit])
		# creating the question tags limit
		if scn_tag_limit.save
		# response to the JSON
		  render json: { success: true,message: "Scn Tag limit Successfully Updated.",response: {scn_tag_limit: scn_tag_limit.scn_tag_limit.as_json }},:status=>200
	    else
	      render :json=> { success: false, message: scn_tag_limit.errors },:status=> 203
	    end	
	end

	# Method for setting the app color according to the select value
	def set_app_color
		# update the color values with params of color
		if setting.update(type_app_color: params[:color])
		# response to the JSON
		  render json: { success: true,message: "Color Successfully Updated.",response: {color: setting.type_app_color.as_json }},:status=>200
	    else
	      render :json=> { success: false, message: setting.errors },:status=> 203
	    end		
	end

	#method for showing the about content.
	def about
		content = Content.first.about_content
		if content.present?
		# response to the JSON
      	  render json: { success: true, response: {about_content: content.as_json} },:status=> 200
	    else
	      render :json=> { success: false, message: "About Content is not present" },:status=> 203
	    end 
	end

	#method for showing help content.
	def help
		helps = Help.all
		if helps.present?
		# response to the JSON
      	  render json: { success: true, response: {help_content: helps.as_json} },:status=> 200
	    else
	      render :json=> { success: false, message: "Help Content is not present" },:status=> 203
	    end
	end

	# Method for user send feedback to the admin
	def user_send_feedback
		# send feed back to the admin
		if UserMailer.feedback(current_user,params[:feedback_text]).deliver_now
		# response to the JSON
      	  render json: { success: true, message: "Feedback has sent successfully" },:status=> 200
	    else
	      render :json=> { success: false, message: "problem with sending feedback" },:status=> 203
	    end	
	end

	# Method for user send report to the admin
	def user_send_report
		# send report issue to the admin
		if UserMailer.report_issue(current_user,params[:report_text]).deliver_now
		# response to the JSON
      	  render json: { success: true, message: "Report has sent successfully" },:status=> 200
	    else
	      render :json=> { success: false, message: "problem with sending report" },:status=> 203
	    end	
	end

private

	def setting
		# Condition for checking the setting exits for surgeon
		if current_user.setting.blank?
			#Initialize setting for surgeon
			setting = current_user.build_setting
			# Saving setting information for surgeon
			setting.save
		else
			#Fetch setting information for surgeon
			setting = current_user.setting
		end
	end
end
