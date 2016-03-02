class CaseMediaAttachmentsController < ApplicationController
	# Find the particular case before method
	before_action :find_case, only: [:edit,:attachment_destroy,:update,:attachment_update,:show]
	# Before action need to find the particular case media
	before_action :find_case_media,only: [:edit]
	# Before action need to find the particular case media
	before_action :find_case_media_attachement,only: [:edit,:update,:show,:destroy,:attachment_update,:attachment_destroy]
	# Before action need to crop the  the particular image of case attachment
	before_action :crop_media_image,only: [:update]	
	# Before action need to crop the  the particular image of case attachment
	before_action :rotate_media_image,only: [:update]
	# before action need to check the tags count
	before_action :count_tags,only: [:show,:attachment_update,:update]
	# before action need to count no of question tags limit
	before_action :attachment_tag_count,only: [:update,:attachment_update]
	# Before action need to find the user type
	before_action :check_admin
    # before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user

	# Method for creating the media for particular case
	def update
		# Updating the case media attachments accordin to the  case media
		@case_media_attachment.update(case_media_attachment_params)
		# After update redirect ot the case page
		redirect_to case_case_media_path(@surgery_case)
	end

	# Method for Updating the attachment media for particular case
	def attachment_update
		if  @media_tag_count <= @tag_count
			# Updating the case media attachments according to the  case media
			@case_media_attachment.update(case_media_attachment_params)
			# After update redirect ot the case page
			@path = case_case_media_path(@surgery_case)
			@type = 'success'
		else
			@msg = "only #{@tag_count} tags allowed"
			@type = 'error'
		end
		render json: {path: @path, msg: @msg, type: @type}
	end

	# Method for deleting the particular attachment
	def attachment_destroy
		# destroy the particular attachment
		@case_media_attachment.destroy
		# after delete that is navigating to the case media page
		case_case_media_path(@surgery_case)
	end


	# Method for finding the particular case media 
	def edit
	end

	# Method for finding the particular case media attachments
	def show
	end

	# Method for destroying the particular attachments
	def destroy
		# Destroy the Particular case media attachment
		@case_media_attachment.destroy
		# After destroying the attachment then that is navigating to the case media edit page
		redirect_to :back
	end

	# Method for destroying the particular attachments
	def attachment_destroy
		# Destroy the Particular case media attachment
		@case_media_attachment.destroy
		# After destroying the attachment then that is navigating to the case media index page
		case_case_media_path(@surgery_case)
	end

	def search_tags		
		# Searching for patients as per user entered term
		case_media_attachment_tags = CaseMediaAttachment.all_tags.select{|p| p=~/^#{params[:term]}/i }.uniq.to_json
		respond_to do |format|
		  format.json { render :json => case_media_attachment_tags }
		end
	end

	private

	def case_media_attachment_params
		# Permitting the params with nested attributes of the case media attachments
		params.require(:case_media_attachment).permit!
	end
		
	# Method for finding the particualr from params
	def find_case
		# Finding the particular case
		@surgery_case = Case.find(params[:case_id])
	end


	# Method for Find the particular case media
	def find_case_media
		@case_medium = CaseMedium.find(params[:case_medium_id])
	end

	# Method for Find the particular case find case media attachement
	def find_case_media_attachement
		@case_media_attachment = CaseMediaAttachment.find(params[:id])
	end

	# Creating the Crop Image getting the parameter from cropped image method
	def crop_media_image
		if params[:cord].values.reject(&:blank?).count == params[:cord].values.count
			params[:case_media_attachment][:attachment] = cropped_image(params, @case_media_attachment.attachment.case_image.path)
		end	
	end

	# Getting the all the Crop Image Dimension after cropping the image
	def cropped_image(params, image_path)
	    image = MiniMagick::Image.open(image_path)
	    crop_params = "#{params[:cord][:w]}x#{params[:cord][:h]}+#{params[:cord][:x]}+#{params[:cord][:y]}"
	    image.crop(crop_params)
	    image
	end

	# Creating the Rotate Image getting the parameter from rotate image method
	def rotate_media_image
		if !params[:degree_angle].blank?
			params[:case_media_attachment][:attachment] = rotateted_media_image(params[:degree_angle], @case_media_attachment.attachment.case_image.path)
		end
	end
	
	# Getting the all the Algle of the Image after rotate the image
	def rotateted_media_image(angle, image_path)
	    image = MiniMagick::Image.open(image_path)
	    image.rotate(angle)
	    image
	end

	# count no of tag for the media attachment
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

	# count the no of tag limit for the questions
	def attachment_tag_count
		# find the params of attachment tags
		tags = params[:case_media_attachment][:tags]
		# count the no of tags for that particular attachment
		@media_tag_count = tags.split(",").count
	end

end
