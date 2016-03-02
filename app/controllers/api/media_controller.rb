class Api::MediaController < Api::BaseController
	# Before action find the question id
	before_action :check_parameter, only: [:sort_search_media]
    respond_to :json

	# Method for displying the all the media files and search the media files
	def index
		case_media = current_user.case_media.map(&:case_media_attachments).flatten.map{|attachment| attachment if attachment.attachment_type=='image'}.compact
	    # check condition for case media is present or not.
		if case_media.present?
		# response to the JSON
	      render json: { success: true, response: case_media.map(&:attachment).as_json }
	    else
	      render :json=> { success: false, message: "Media are not present" },:status=> 203
	    end 
	end

    # Search media according to the keyword
	def media_search
		case_media = media_list(params[:searchterm])
		# check condition for case media is present or not.
		if case_media.present?
		# response to the JSON
	      render json: { success: true, response: case_media.map(&:attachment).as_json }
	    else
	      render :json=> { success: false, message: "Media are not present" },:status=> 203
	    end 
	end

    # Method for filter media 
	def sort_search_media
		# sort the cases by last week, last year, last month and all
		case_media = media_list(params[:searchterm]).send(params[:sort_type])
		# check condition for case media is present or not.
		if case_media.present?
		# response to the JSON
	      render json: { success: true, response: case_media.map(&:attachment).as_json }
	    else
	      render :json=> { success: false, message: "Media are not present" },:status=> 203
	    end
	end

	def group_search_media
		# grop the cases by last week, last year, last month and all
		case_media = media_list(params[:searchterm]).send(params[:sort_type])
		# check condition for case media is present or not.
		if case_media.present?
		# response to the JSON
	      render json: { success: true, response: case_media.map(&:attachment).as_json }
	    else
	      render :json=> { success: false, message: "Media are not present" },:status=> 203
	    end
	end

	private

	def media_list(searchterm)
		CaseMediaAttachment.where(
			:case_medium_id.in=>current_user.case_media.map(&:id),
			:tags => /^#{searchterm}/i
      )
	end

    # Check params is nil or not.
    def check_parameter
    	# response to the JSON if searchterm or sort_type is not present.
    	render json: {success: false, message: 'Something wrong with the parameters'}, status: 400 if (params[:searchterm].nil? || params[:sort_type].nil?)
    end
end
