class Cases::CaseMediaController < ApplicationController
	# include the case medium helper
	include CaseMediumHelper
	# Find the particular case before method
	before_action :find_case,only: [:index,:new,:edit,:create,:share_timeline,:update,:destroy]
	# Find the list of the case notes before method
	before_action :list_case_notes,only: [:index,:share_timeline]
	# Before action need to find the particular case media
	before_action :find_case_media,only: [:edit,:update,:destroy]
	# Before action need to find the particular case activities
	before_action :case_activity_list,only: [:index,:share_timeline]
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to check the limit for the case media
	before_action :count_tags,only: [:edit]



	# Method for initialize the Case Media Form
	def new
		# Initialize the Case Media Form
		@case_medium = CaseMedium.new
		# Initialize the Case Media with Case Media attachments
		@case_media_attachments = @case_medium.case_media_attachments.build
	end

	# Method for creating the media for particular case
	def create
		params[:case_medium][:owner_id] = devise_current_user.id.to_s
		# Creating the case media attachments according to the surgeon
		@case_media = current_user.case_media.new(case_media_params)
		if !current_user.setting.media_upload.nil?
			# Condition For checking the case media attachments are store into database or not
			@attachment_size = check_size_attachment(@case_media)
			 if !(@attachment_size.include? false)
				if @case_media.save
					# After creating the case media attachment redirect the case media edit page
					redirect_to edit_case_case_medium_path(@surgery_case,@case_media)
				else
					# If case media is not creating the that is take into the same page
					redirect_to :back
					# Showing the warning message for the if image is not uploaded
					flash[:notice] = "Cannot upload more than 10 images at one go"
				end
			else
			 # If case media is not creating the that is take into the same page
			 redirect_to :back
			 # Showing the warning message for the if image is not uploaded
			 # flash[:notice] = "each attachment size limit is not more than 64MB"
			  flash[:notice] = "Attachments size limit is exceed"
			end
		else
		 # If case media is not creating the that is take into the same page
			redirect_to :back
		 # Showing the warning message for the if image is not uploaded
			flash[:notice] = "please assign the size limit of the attachment in media upload settings"
		end
	end

	# Method for creating the media for particular case
	def update
		params[:case_medium][:owner_id] = devise_current_user.id.to_s
		# Updating the case media attachments accordin to the  case media
		if @case_medium.update(case_media_params)
		 # After update redirect ot the case page
		 redirect_to edit_case_case_medium_path(@surgery_case,@case_medium)
		else
			# If more than 10 images then that is navigate the same page
			redirect_to edit_case_case_medium_path(@surgery_case,@case_medium)
			# if image is not uploaded then that showing the flash notice
			flash[:notice] = "Cannot upload more than 10 images at one go"
		end
	end
	

	# Method for the listing the timeline for the particular case
	def index
		@timeline_user =devise_current_user
	end

	# Method for finding the particular case media 
	def edit
		# All the case media attachment according the particular case media in the ascending orde accoding created at
		@case_media_attachments = @case_medium.case_media_attachments.all.order('case_media_attachments.created_at ASC')
	end


	# Method for generating whole timeline in the format of pdf
	def share_timeline
		respond_to do |format|
			format.pdf do
       	render pdf: "share_timeline"
     	end
		end
	end

	# Method for destroying the particular case media
	def destroy
		# Desttroy the particular case media with all the attachment files
		@case_medium.destroy
		# Redirect to the case media index page after destroy case medium
		redirect_to case_case_media_path(@surgery_case)
	end



	private

	# Method for permitting he case media params
	def  case_media_params
		# Permitting the params with nested attributes of the case media attachments
		params.require(:case_medium).permit(:case_id,:owner_id, case_media_attachments_attributes: [:attachment, :note,:tags])
	end
		
	# Method for finding the particualr from params
	def find_case
		# Finding the particular case
		@surgery_case = Case.find(params[:case_id])
	end

	# Method for list out the all the notes for case notes
	def list_case_notes
		@case_notes = CaseNote.where(case_id: params[:case_id])
	end

	# Method for Find the particular case media
	def find_case_media
		@case_medium = CaseMedium.find(params[:id])
	end

	# Method for finding the all the case media for that particular case
	def case_media_list
		@case_media_attachments = @surgery_case.case_media.case_media_attachments
	end

	# Method for list out the activities of the cases
	def case_activity_list
		@case_activitites = @surgery_case.case_activities
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
end