class Api::CaseMediaAttachmentsController < Api::BaseController
	# Before action need to find the particular case media
	before_action :find_case_media_attachement,only: [:show,:destroy,:update,:attachment_update]
	# Before action need to crop the  the particular image of case attachment
	before_action :crop_media_image, :rotate_media_image, only: [:update]
	# before action need to check the count of tags setting
	before_action :count_tags,only: [:update,:attachment_update]
	# before action need to check the count of current tags
	before_action :current_tags_count,only: [:update,:attachment_update]
	
	# Method for finding the particular case media attachments
	def show
		if @case_media_attachment.present?
		# response to the JSON
	      render json: { success: true, response: CaseMediaAttachmentSerializer.new(@case_media_attachment).as_json(root: false) },:status=>200
	     return
	    else
	      render :json=> { success: false, message: "Case Media Attachment is not available" },:status=> 404
	     return
	    end
	end

	# Method for updating the media for particular case
	def update
	    if current_tags_count <= count_tags
			if @case_media_attachment.update_attributes(:attachment=>params[:attachment],:tags=>params[:tags],:note=>params[:note])
				render json: { success: true,message: "Case Media Successfully Updated.", response: CaseMediaAttachmentSerializer.new(@case_media_attachment).as_json(root: false) },:status=>200
		    else
		        render :json=> { success: false, message: @case_media_attachment.errors },:status=> 203
		    end
		else
			render :json=> { success: false, message: "only #{count_tags} tags allowed" },:status=> 203
		end
	end

    # Method for Updating the attachment media for particular case
	def attachment_update
		if current_tags_count <= count_tags
			# Updating the case media attachments according to the  case media
			if @case_media_attachment.update_attributes(:tags=>params[:tags],:note=>params[:note],:location=>params[:location])
	        	render json: { success: true,message: "Case Media Attachment Successfully Updated.", response: CaseMediaAttachmentSerializer.new(@case_media_attachment).as_json(root: false) },:status=>200
		    else
		        render :json=> { success: false, message: @case_media_attachment.errors },:status=> 203
		    end
		else
			render :json=> { success: false, message: "only #{count_tags} tags allowed"},:status=> 404
	    	return
		end
	end

    # Method for destroying the particular attachments
	def destroy
		# Destroy the Particular case media attachment
		if @case_media_attachment.destroy
		# response to the JSON
  			render json: { success: true,message: "Case Media Attachent Successfully Deleted."},:status=>200
    		return
	    else
	      render :json=> { success: false, message: "Case Media Attachent is not available" },:status=> 404
	    	return
	    end	
	end

	def search_tags		
		# Searching for patients as per user entered term
		case_media_attachment_tags = CaseMediaAttachment.all_tags.select{|p| p=~/^#{params[:term]}/i }.uniq 
		if case_media_attachment_tags.present?
	    	render :json=> {success: true, "Tags" => case_media_attachment_tags.as_json }
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Tags are not present" },:status=> 203
	    end
	end

private

	# Method for Find the particular case find case media attachement
	def find_case_media_attachement
		@case_media_attachment = CaseMediaAttachment.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Case Media Attachment ID !'}, status: 400 if @case_media_attachment.nil?
	end

		# Creating the Crop Image getting the parameter from cropped image method
	def crop_media_image
		if !(params[:h] && params[:w] && params[:x] && params[:y]).blank?
			params[:attachment] = cropped_image(params, @case_media_attachment.attachment.case_image.path)
		end
	end

	# Getting the all the Crop Image Dimension after cropping the image
	def cropped_image(params, image_path)
	    image = MiniMagick::Image.open(image_path)
	    crop_params = "#{params[:w]}x#{params[:h]}+#{params[:x]}+#{params[:y]}"
	    image.crop(crop_params)
	    image
	end

	# Creating the Rotate Image getting the parameter from rotate image method
	def rotate_media_image
		if !params[:degree_angle].blank?
			params[:attachment] = rotateted_media_image(params[:degree_angle], @case_media_attachment.attachment.case_image.path)
		end
	end
	
	# Getting the all the Algle of the Image after rotate the image
	def rotateted_media_image(angle, image_path)
	    image = MiniMagick::Image.open(image_path)
	    image.rotate(angle)
	    image
	end

	def current_tags_count
		params[:tags].count if params[:tags]
	end

	def count_tags
		# checking the setting media tags is there or not
		if current_user.setting
			# count the media tag count id more than 0
			if current_user.setting.media_tag_limit.to_i > 0
				# count limit for that media attachment tag
				@tag_count = current_user.setting.media_tag_limit.to_i
			end
		end
	end

	
end
