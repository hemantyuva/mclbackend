class ProfilesController < ApplicationController
	# Before action need to find the profile
	before_action :find_profile,only: [:show,:edit,:update]
	# Before action need to fid the surgery locations for profile surgeon
	before_action :find_surgery_location,only: [:show,:profile_setting_list]
	# Before actions need to find the all the question vlist for that particular surgeon
	before_action :questions_list,only: [:show,:profile_setting_list]
	# Before Action Need check the setting
	before_action :setting,only: [:create,:new]
	# Before Action Need check the profile setting
	before_action :profile_setting,only: [:user_address,:user_profile_data,:medical_school,:high_school,:residency_diploma,:spe_training,:award,:my_hobbies,:my_favorites,:my_quote,:about_me,:profile_photo,:user_work_phone,:user_home_phone,:profile_setting_list,:specialist_setting,:edit_surgery_name]
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to find the list of the all the things
	before_action :find_list,only: [:user_app_data]
	# before action need to find the user setting
	before_action :find_user_setting,only: [:update_address,:update_high_school,:update_medical_school,:update_residency_diploma,:update_spe_training,:update_award,:update_profile_setting,:update_profile_photo,:update_phone,:update_specialist]
	# before action need to find the user 
	before_action :set_associate_user
	# before action need to find the user 
	before_action :set_user, only: [:show_user_profile]
	#before action find surgery
	before_action :find_surgery, only: [:edit_surgery_name,:update_surgery_name]
	#before action find diagnose
    before_action :find_diagnose, only: [:edit_diagnose_name,:update_diagnose_name]
    

	# Method for the Initialize the Profile
	def new
		# Initialize the profile form with surgeon
		@surgeon_profile = devise_current_user.setting.build_profile
	end

	# Method for Creating the profile with surgeon
	def create
		# Creating the profile for particular surgeon
		surgeon_profile = devise_current_user.setting.build_profile(profile_params) 
		# Condition checking the profile is saved or not
		if surgeon_profile.save
			# If Profile is save then that's take it into the profile show page
			redirect_to profile_path(surgeon_profile)
		else
			# If Profile is not save then that's take in into the same page 
			redirect_to :back
		end #Condition End
	end

	# Find the particular profile details
	def show
		# Initializing the Inivitation form from profile page
	end

	# showing the list of the profile setting details
	def profile_setting_list
		# find the home address
		@home_addresses = @profile_setting.addresses.where(address_type: "home")
	end

	# Method for finding the particular profile details
	def edit
		#Find the Particular Profile
		@surgeon_profile = @profile
	end

	# Method for updating the particular profile details
	def update
		# Updating the details according the that particular profile
		@profile.update_attributes(profile_params)
		# Redirect to the particular surgeon profile show page
		redirect_to profile_path(@profile)
	end

	# method for find the user profile data of the address
	def user_profile_data
		@user = devise_current_user
		# find the work address
		@work_addresses = @profile_setting.addresses.where(address_type: "work").count
		# find the home address
		@home_addresses = @profile_setting.addresses.where(address_type: "home").count
	end
	
	# Method for user app data page
	def user_app_data
		# assign devise user as instance variable
		@user = devise_current_user
	end

	# Method for user work phone page
	def user_work_phone
	end

	def update_phone
		@phone = @user.update_attributes(phone_params)
		# redirect to the profile app page
		redirect_to user_profile_data_profile_path
	end

	# Method for user home phone page
	def user_home_phone
	end

	# Method for user address page
	def user_address
	end

	# Method for Update the user profile address inside the setting
	def update_address
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			@address = @user.update_attributes(address_params)
			if @address
				# redirect to the profile app page
				redirect_to user_profile_data_profile_path
			else
				# redirect to the user address page
				redirect_to user_address_profiles_path(type: params[:address_type])
				flash[:notice] = "Address can't be blank"
			end
		end
	end

	# Method for high school the page
	def high_school
	end

	# Method for Update the user profile high school inside the setting
	def update_high_school
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# update the user school with high school params
			@high_school = @user.update_attributes(high_school_params)
			if @high_school
				# redirect to the profile app page
				redirect_to user_profile_data_profile_path
			else
				# redirect to the user high school page
				redirect_to high_school_profiles_path
				flash[:notice] = "High school name can't be blank"
			end
		end
	end

	# Method for medical school the page
	def medical_school
	end

	# Method for Update the user profile medical school inside the setting
	def update_medical_school
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# update the user medical school with medical_school_params
			@medical_school = @user.update_attributes(medical_school_params)
			if @medical_school
				# redirect to the profile app page
				redirect_to user_profile_data_profile_path
			else
				# redirect to the user medical school page
				redirect_to medical_school_profiles_path
				flash[:notice] = "Medical school name can't be blank"
			end
		end
	end

	# Method for residency the page
	def residency_diploma
	end

	# Method for Update the user residency diploma inside the setting
	def update_residency_diploma
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# Method for the creating the residency or diploma attributes
			@residency_diploma = @user.update_attributes(residency_diploma_params)
			# redirect to the profile app page
			redirect_to user_profile_data_profile_path
		end
	end

	# Method for specility training page
	def spe_training
	end

	# Method of update the user spec training inside the setting
	def update_spe_training
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# creating the spec training the according the spe training params
			@spe_training = @user.update_attributes(spe_training_params)
			# redirect to the profile app page
			redirect_to user_profile_data_profile_path
		end
	end

	# Method for creating the award page
	def award
	end

	# Method for update the award attributes
	def update_award
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# creating the award by using the award params
			@award = @user.update_attributes(award_params)
			# redirect to the profile app page
			redirect_to user_profile_data_profile_path
		end
	end

	# Method for to show the update page of my habbies
	def my_hobbies
	end

	# Method for creating the my favorites page
	def my_favorites
	end

	# Method for creating the my quote page
	def my_quote
	end

	# Method for creating the about me page
	def about_me
	end
	# Method for creating the profile setting attributes
	def update_profile_setting
	 if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# creating the award by using the award params
			profile_setting = @user.update(update_profile_setting_params)
			# redirect to the profile app page
			redirect_to user_profile_data_profile_path
		end
	end

	# Method for listing the all the surgery name list
	def surgery_name_list
		@surgeries = devise_current_user.surgeries.to_a.uniq {|surgery| surgery.name}
	end

	# Method for edit the surgery name 
	def edit_surgery_name
	end

	# Method for update the surgery name 
	def update_surgery_name
		@surgery.update(surgery_params)
		redirect_to surgery_name_list_profiles_path
	end

	# Method for listing the all the diagnose name list
	def diagnosis_name_list
		@diagnose = devise_current_user.diagnose.to_a.uniq {|diagnosis| diagnosis.name}
	end

	# Method for edit the diagnose name 
	def edit_diagnose_name
		
	end

	# Method for update the diagnose name 
	def update_diagnose_name
		@diagonse.update(diagonse_params)
		redirect_to diagnosis_name_list_profiles_path
	end

	# Method for showing the profile photo
	def profile_photo
	end

	# Method for updating the profile setting images
	def update_profile_photo
		# checking the profile setting is present or not
		if !params[:profile_setting].present?
			# if present then navigate to the page
			redirect_to :back 
		else
		# update the profile update images like cover photo and profile photo
		 @profile_photos = @user.update_attributes(profile_setting_photo_params)
		 # redirect to the user profile app page
		 redirect_to user_profile_data_profile_path
		end
	end

	# Method for showing the specialist_setting page
	def specialist_setting
	end

	# Method for updating the speciality and sub speciality names
	def update_specialist
		if !params[:profile_setting].present?
			redirect_to user_profile_data_profile_path 
		else
			# update the profile update images like cover photo and profile photo
		 	@profile_specialist = @user.update_attributes(profile_setting_specialist_params)
		 	# redirect to the user profile app page
		 	redirect_to user_profile_data_profile_path
		end
	end

	# Search the specialist name from all the specialities
	def profile_specialist_search
		# search the the speciality name according to the terms
		specialities = Speciality.any_of({ :name => /^#{params[:term]}/i }).all.collect{|speciality|  {label: speciality.name ,value: speciality.id.to_s}}.to_json 
		# render to the surgery name page
		respond_to do |format|
		  format.json { render :json => specialities }
		end
	end

	#show user publick profile
	def show_user_profile
		# find the home address
		@home_addresses = @profile_setting.addresses.where(address_type: "home")
	end

	private

	# Method for permitting the phone pages
	def phone_params
		params.require(:profile_setting).permit(:home_phone,:work_phone)
	end

	# Method for permitting the address pages
	def address_params
		params.require(:profile_setting).permit( addresses_attributes: [:id, :address_location,:address_type, :_destroy])
	end

	# Permitting the high school params
	def high_school_params
		params.require(:profile_setting).permit( high_schools_attributes: [:id, :text, :_destroy])
	end

	# Permitting the medical scholl page params
	def medical_school_params
		params.require(:profile_setting).permit( medical_schools_attributes: [:id, :text, :_destroy])
	end

	# Method for Permitting the residency diploma params
	def residency_diploma_params
		params.require(:profile_setting).permit( residency_diplomas_attributes: [:id, :text, :_destroy])
	end

	# Method for permitting the spec trainging params
	def spe_training_params
		params.require(:profile_setting).permit( spe_trainings_attributes: [:id, :text, :_destroy])
	end

	# Method for permitting the award params
	def award_params
		params.require(:profile_setting).permit( awards_attributes: [:id, :text, :_destroy])
	end

	# Method for permitting the profile setting params
	def update_profile_setting_params
		params.require(:profile_setting).permit(:my_hobby,:my_favorite,:my_quote,:about_text)
	end

	# Method for permitting the specialist params
	def profile_setting_specialist_params
		params.require(:profile_setting).permit(:specialist_name,sub_speciality_names_attributes: [:id, :text, :_destroy])
	end

	# Permitting the profile params attribute
	def profile_params
		# Permitting the particular profile params
		params.require(:profile).permit(:speciality_name,:sub_speciality_name,:medical_school,:residency,:spe_training,:my_favourite,:my_hobby,:more_about,:cover_image,:profile_image)
	end

	# Method for permitting the profile setting attributes
	def profile_setting_photo_params
		# Permitting the profile photo params
		params.require(:profile_setting).permit(:profile_image,:cover_image)
	end
    
    # Method for permitting the profile setting attributes
	def surgery_params
		# Permitting the profile photo params
		params.require(:surgery).permit(:name)
	end

	# Method for permitting the profile setting attributes
	def diagonse_params
		# Permitting the profile photo params
		params.require(:diagnose).permit(:name)
	end

	# Method for Finding the particular profile for the surgeon
	def find_profile
		# Find particular Profile 
		@profile = Profile.find(params[:id])
	end

	# Method for Find the all surgery location for the profile surgeon
	def find_surgery_location
		# Find the surgeon location based on the profile
		@surgery_locations = devise_current_user.setting.surgery_locations.all
	end

	# Method for find all the question for the particular profile surgeon
	def questions_list
		# List of the questions for the particular surgeon
		@questions = devise_current_user.questions.all
	end

	# Method the surgery by name
	def find_surgery
		@surgery = Surgery.find(params[:id])
	end

	def find_diagnose
		@diagonse = Diagnose.find(params[:id])
	end

	# Method for finding the all the list mention over here
	def find_list
		# find the all the surgery locations
		@surgery_locations = devise_current_user.setting.surgery_locations.count
		# find the all the surgeries
		@surgeries = devise_current_user.surgeries.count
		# find the all the diagnoses
		@diagnose = devise_current_user.diagnose.count
	end

	# fins the user setting
	def find_user_setting
		# find the user setting
		@user = devise_current_user.profile_setting
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

	def profile_setting
		# Condition for checking the profile setting exits for surgeon
		if devise_current_user.profile_setting.blank?
			#Initialize profile setting for surgeon
			profile_setting = devise_current_user.build_profile_setting
			# Saving profile setting information for surgeon
			profile_setting.save
		else
			#Fetch  profile setting information for surgeon
			@profile_setting = devise_current_user.profile_setting
		end
	end
    
    def set_user
    	@user =User.find(params[:id])
    	# Condition for checking the profile setting exits for surgeon
		if @user.profile_setting.blank?
			#Initialize profile setting for surgeon
			profile_setting = @user.build_profile_setting
			# Saving profile setting information for surgeon
			profile_setting.save
		else
			#Fetch  profile setting information for surgeon
			@profile_setting = @user.profile_setting
		end
		# Condition for checking the setting exits for surgeon
		if @user.setting.blank?
			#Initialize setting for surgeon
			setting = @user.build_setting
			# Saving setting information for surgeon
			setting.save
		else
			#Fetch setting information for surgeon
			@surgery_locations = @user.setting.surgery_locations.all
		end
    end

	def set_associate_user
		@associate_user = devise_current_user
	end

end
