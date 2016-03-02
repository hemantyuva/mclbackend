class MediaController < ApplicationController
	# require 'will_paginate/array'
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user

	# Method for displying the all the media files and search the media files
	def index
		@case_media = current_user.case_media.map(&:case_media_attachments).flatten.map{|attachment| attachment if attachment.attachment_type=='image'}.compact.paginate(page: params[:page],per_page: 20)
		# ids = current_user.case_media.collect(&:id)
		# @case_media = CaseMediaAttachment.where(tags: {'$ne' => []},attachment_type: {'$eq' => 'image'},:case_medium_id.in => ids).paginate(page: params[:page],per_page: 20)
	end

	# Search media according to the keyword
	def media_search
		@searchterm = current_user.searches.and({:search_term =>params[:searchterm]},{:type=>"media"}).first
		@case_media = media_list(params[:searchterm]).paginate(page: params[:page],per_page: 20)  
		 # respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
	end

	def sort_search_media
		# sort the cases by last week, last year, last month and all
		@case_media = media_list(params[:searchterm]).send(params[:sort_type]).paginate(page: params[:page],per_page: 20)  
		# respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
	end

	def group_search_media
		# grop the cases by photo, audio, video and all
		@case_media = media_list(params[:searchterm]).send(params[:group_type]).paginate(page: params[:page],per_page: 20)  
		# respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
	end

	private
	def media_list(searchterm)
		CaseMediaAttachment.where(
			:case_medium_id.in=>current_user.case_media.map(&:id),
			:tags => /^#{searchterm}/i
      	)
	end
end