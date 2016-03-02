class Api::CaseMediaController < Api::BaseController
# Find the particular case before method
	before_action :find_case,only: [:index,:create,:update]
# Find the particular case before method
	before_action :find_case_media,only: [:update,:destroy]
# check the file limit before create
	before_action :attachment_count,only: [:create,:update]

# Method for the listing the timeline for the particular case
	def index
		if @surgery_case.present?
      	  render json: { success: true, response: @surgery_case.as_json('case_media_index') },:status=> 200
	    else
	      render :json=> { success: false, message: "Cases are not present" },:status=> 203
	    end 
	end

	# Method for creating the media for particular case
	def create
		if !current_user.setting.media_upload.media_upload_limit.blank?
			@case_media = @surgery_case.case_media.create(user_id:current_user.id,owner_id:current_user.id)
			# Creating the case media attachments according to the surgeon
			if !params[:file].nil?
			  @attachment_size = check_size_attachment(@case_media)
			  if !(@attachment_size.include? false)
					params[:file].each do |image| 
						@case_media_attachment = @case_media.case_media_attachments.new(:attachment => image)
					end
					if @case_media_attachment.save
					render json: { success: true,message: "Case Media Successfully Created.", response: @case_media_attachment.as_json },:status=>200
					else
					render json: { success: false,message: "Attachments size limit is exceed."},:status=>203
					end
        end
			end
		else
			render json: { success: false,message: "please assign the size limit of the attachment in media upload settings."},:status=>203
		end
	end

# Method for creating the media for particular case
	def update
		if @case_media.present?
			if !params[:file].nil?
				# @case_media.case_media_attachments.create(image:image)
				@case_media_attachment = CaseMediaAttachment.where(id:params[:case_media_attachment_id])[0]
				@case_media_attachment = @case_media_attachment.update_attributes(:attachment => params[:file],note:params[:note],tags:params[:tags])
			end
				render json: { success: true,message: "Case Media Successfully Updated.", response: @case_media.case_media_attachments.as_json },:status=>200
			else
		    render :json=> { success: false, message: "Case Media is not available" },:status=> 404
			end
	end

	# Method for destroying the particular case media
	def destroy
		# Desttroy the particular case media with all the attachment files
		if @case_media.destroy
		# response to the JSON
			render json: { success: true,message: "Case Media Successfully Deleted."},:status=>200
  		return
    else
      render :json=> { success: false, message: "Case Media is not available" },:status=> 404
    	return
    end
	end

private
    # Method for finding the particualr case
	def find_case
		# Finding the particular case
		@surgery_case = Case.where(id:params[:case_id])[0]
		render json: {success: false, message: 'Invalid Case ID !'}, status: 400 if @surgery_case.nil?
	end

    # Method for finding the particualr case media
	def find_case_media
		# Finding the particular case media
		@case_media = CaseMedium.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Case Media ID !'}, status: 400 if @case_media.nil?
	end

    # Method for check the limit of image
	def attachment_count
    if params[:file]
    	@image_count = params[:file].count
      render json: {success: false, message: "Cannot upload more than 10 images at one go"}, status: 400 if @image_count > 10
    end  
	end

	# Method for cheching the attachement size limit
	def check_size_attachment case_media
		if current_user.setting.media_upload.try(:media_upload_limit)
			size_limit = current_user.setting.media_upload.media_upload_limit.to_i
			# collecting all the case media of case media attachments
			attachment_size = case_media.case_media_attachments.collect{|attachement| attachement.attachment.size <= size_limit*1024*1024}
		end
	end
 
end
