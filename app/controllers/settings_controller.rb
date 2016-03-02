class SettingsController < ApplicationController
  # Before action need to check the setting
  before_action :setting
  # Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	
	def index
		@setting = setting
	end

	# Method for checking the session timeout limit
	def session_timeout
		# assign the devise current user as the user
		@user 
	end

	# Method for checking the session time
	def check_session_time
		# updating the setting using the time limit parameters
		timeout = setting.update(session_max: params[:time_limit])
		# redirect to the same page of session time page
		redirect_to session_timeout_settings_path
	end

	def create
		# Method for surgeon creating the new surgerylocation 
		@setting = @user.build_setting(setting_params)
		@setting.save
	end

	def update
		# Method for surgeon updating the new surgerylocation 
		@setting = setting.update(setting_params)
		# redirect to the patient schedule new page
	end

	# Method for setting tags
	def tag_setting
		# find the media tag limit
		@media_tag = setting.media_tag_limit.to_i
		# find the scn tag limit
		@scn_tag = setting.scn_tag_limit.to_i
	end
	
	# Method for setting the media upload files limit
	def media_upload_setting
		# find the media upload 
		@media_upload = setting.media_upload
	end

	# Method for setting the media upload size limit
	def media_upload_limit
		# Initialize the media upload setting
		@media_upload_setting = setting.build_media_upload
	end

	# Method for setting the passcodes in setting 
	def passcodes_setting
		# find the particular user updated passcode
		@passcodes = @user.passcode
	end

	# Method for set the limit for the media upload
	def set_media_upload_limit
		# Creating the limitation for the question tags
		@media_upload_limit = setting.build_media_upload(media_upload_params)
		# creating the question tags limit
		@media_upload_limit.save
		# redirect to the tags setting page
		redirect_to media_upload_setting_settings_path
	end

	# Method for setting the value of the color
	def color_palette_setting
		@type_app_color = setting.type_app_color
	end

	# Method for showing the about for the surgeon
	def show_about
	end

	# Method for setting the app color according to the select value
	def set_app_color
		# update the color values with params of color
		setting.update(type_app_color: params[:color])
		# redirect to the same page of color palette page
		redirect_to :back
	end

	# Method for showing the all help video for surgeon
	def show_help_video
		@helps = Help.all
	end

	# Method for legal and privacy
	def legal_privacy
	end

	# Method for showing the report issue page
	def report_issue
		# setting to the particular page
		@setting = setting
	end

	# show the send feedback page
	def send_feedback
		# setting to the particular page
		@setting = setting
	end

	# Method for user send feedback to the admin
	def user_send_feedback
		# send feed back to the admin
		UserMailer.feedback(@user,params[:feedback_text]).deliver_now
		# redirect to the setting path
		redirect_to settings_path
	end

	# Method for user send report to the admin
	def user_send_report
		# send report issue to the admin
		UserMailer.report_issue(@user,params[:report_text]).deliver_now
		# redirect to the setting path
		redirect_to settings_path
	end

	# Method for setting the media and scn tag limit
	def set_tag_limit
		# Method for updating the tag limit for media attachment and also scn question
		params[:media_tag_limit] ? setting.update(media_tag_limit: params[:media_tag_limit]) : setting.update(scn_tag_limit: params[:scn_tag_limit]) 
		# redirect to the setting page
		redirect_to settings_path
	end

	private
	 # Permitting the Setting Attributes
	def setting_params
		params.require(:setting).permit(surgery_locations_attributes: [:name, :id])
	end

	# Method for the media upload attributes
	def media_upload_params
		# permitting the media upload parameters
		params.require(:media_data_media_upload).permit(:media_upload_limit)
	end

	def setting
		# find the devise current user as the current user
		@user = devise_current_user
		# Condition for checking the setting exits for surgeon
		if @user.setting.blank?
			#Initialize setting for surgeon
			setting = @user.build_setting
			# Saving setting information for surgeon
			setting.save
		else
			#Fetch setting information for surgeon
			setting = @user.setting
		end
	end
	
end
