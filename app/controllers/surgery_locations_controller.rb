class SurgeryLocationsController < ApplicationController
	# before action need to find the setting
	before_action :setting, only:[:create]
	# Before action need to find the user type
 	before_action :check_admin
 	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before need to find the surgery loation
	before_action :find_location,only: [:edit,:update]


	# Method for initialize surgery location params
	def new
		@surgery_location = SurgeryLocation.new
	end

	def create
		if params[:url] == "schedule"
			# if the params is coming from the schedule the permit the only name attributes
			@surgery_location = devise_current_user.setting.surgery_locations.create(name: params[:name])
		else
			# Method for surgeon creating the new surgerylocation 
			@surgery_location = devise_current_user.setting.surgery_locations.create(surgery_location_params)
			# redirect to the surgerylocations index page
			redirect_to surgery_locations_path
		end
	end

	# Method for listing out the all the surgery locations
	def index
		@surgery_locations = devise_current_user.setting.surgery_locations.all
	end

	# Method for editing the surgery form
	def edit
	end

	# Method for updating the surgery form
	def update
		# updating the surgery location attribute
		@surgery_location.update(surgery_location_params)
		# redirect to the surgerylocations index page
		redirect_to surgery_locations_path
	end


private
	def surgery_location_params
		params.require(:surgery_location).permit(:name,:address,:phone)
	end

	def setting
		# Condition for checking the setting exits for surgeon
		if devise_current_user.setting.blank?
			#Initialize setting for surgeon
			setting = devise_current_user.build_setting
			# Saving setting information for surgeon
			setting.save
		else
			#Fetch setting information for surgeon
			setting = devise_current_user.setting
		end
	end

	# Method for finding the particular surgery location
	def find_location
		@surgery_location = SurgeryLocation.find(params[:id])
	end

end