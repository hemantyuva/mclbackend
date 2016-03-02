class Api::ProfilesController < Api::BaseController
	# Before action need to find the profile
	before_action :find_profile,only: [:show,:update]
	# Before action need to fid the surgery locations for profile surgeon
	before_action :find_surgery_location,only: [:show]
	# Before Action Need check the setting
	before_action :setting,only: [:create]
	# Before Action Need check the profile setting
	before_action :profile_setting,only: [:user_profile_data]
	#Before Action need to find user setting
	before_action :find_user_setting,only: [:update_address,:update_high_school,:update_medical_school,:update_residency_diploma,:update_spe_training,:update_award,:update_my_hobbies,:update_my_favorites,:update_my_quote,:update_about_me,:update_profile_photo,:update_phone,:update_work_phone,:update_home_phone,:update_specialist,:user_profile_data,:user_app_data]

	# Method for Creating the profile with surgeon
	def create
		# Creating the profile for particular surgeon
		surgeon_profile = current_user.setting.build_profile(speciality_name: params[:speciality_name],sub_speciality_name:params[:sub_speciality_name],:medical_school=>params[:medical_school],:residency=>params[:residency],:spe_training=>params[:spe_training],:my_favourite=>params[:my_favourite],:my_hobby=>params[:my_hobby],:more_about=>params[:more_about],:cover_image=>params[:cover_image],:profile_image=>params[:profile_image]) 
		# Condition checking the profile is saved or not
		if surgeon_profile.save
		# response to the JSON
		  render json: { success: true,message: "Profile Successfully Created.", response: surgeon_profile.as_json },:status=>200
	    else
	      render :json=> { success: false, message: surgeon_profile.errors },:status=> 203
	    end
	end

	# Method for updating the particular profile details
	def update
		# Updating the details according the that particular profile
		if @profile.update_attributes(speciality_name: params[:speciality_name],sub_speciality_name:params[:sub_speciality_name],:medical_school=>params[:medical_school],:residency=>params[:residency],:spe_training=>params[:spe_training],:my_favourite=>params[:my_favourite],:my_hobby=>params[:my_hobby],:more_about=>params[:more_about],:cover_image=>params[:cover_image],:profile_image=>params[:profile_image])
		# response to the JSON
			render json: { success: true,message: "Profile Successfully Updated.", response: ProfileSerializer.new(@profile).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: @profile.errors },:status=> 203
	    end
	end

	# Find the particular profile details
	def show		
		# response to the JSON
		render json: { success: true, response: @profile.as_json },:status=>200	    
	end

	def user_profile_data
		user = current_user
		work_addresses = @profile_setting.addresses.where(address_type: "work").count
		home_addresses = @profile_setting.addresses.where(address_type: "home").count
		high_schools = @user.high_schools.count
		medical_school = @user.medical_schools.count
		residency_diplomas = @user.residency_diplomas.count
		spre_training = @user.spe_trainings.count
		if @user.present?
		   render json: { success: true, response: {email: user.email, work_addresses:work_addresses,home_addresses:home_addresses,high_schools: high_schools,medical_school: medical_school, residency_diplomas: residency_diplomas,spre_training: spre_training ,my_hobby: @profile_setting.my_hobby, my_favorite: @profile_setting.my_favorite,my_quote:@profile_setting.my_quote,about_text:@profile_setting.about_text} },:status=> 200
	    else
	      render :json=> { success: false, message: "User profile data are not present" },:status=> 203
	    end
	end

    # Method for user app data page
	def user_app_data
		user = current_user
		surgery_locations = SurgeryLocation.all.count
		if user.present?
		# response to the JSON
      	  render json: { success: true, response: {my_surgeries: user.surgeries.count, my_diagnose: user.diagnose.count, manage_assistants: user.manage_assistants.count,surgery_locations: surgery_locations} },:status=> 200
	    else
	      render :json=> { success: false, message: "User App data are not present" },:status=> 203
	    end 
	end

	def update_work_phone
		if @user.update_attributes(work_phone: params[:work_phone])
		# response to the JSON
		  render json: { success: true,message: "Phone Successfully Updated.", response: {work_phone: @user.work_phone } },:status=>200
	    else
	      render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

    def update_home_phone
		if @user.update_attributes(home_phone: params[:home_phone])
	    # response to the JSON
		  render json: { success: true,message: "Phone Successfully Updated.", response: {home_phone: @user.home_phone }},:status=>200
	    else
	      render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_address
		if @user.update_attributes(params[:address].permit!)
		# response to the JSON
			render json: { success: true,message: "Address Successfully Updated.", response: {addresses: @user.addresses.map{|x| x.address_location if params[:type]==x.address_type}.compact } },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_high_school
		if @user.update_attributes(params[:profile_setting].permit!)
		# response to the JSON
			render json: { success: true,message: "High school Successfully Updated.", response: {high_school: @user.high_schools.map(&:text)} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_medical_school
		if @user.update_attributes(params[:profile_setting].permit!)
		# response to the JSON
			render json: { success: true,message: "Medical school Successfully Updated.", response: {medical_school: @user.medical_schools.map(&:text)} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_residency_diploma
		if @user.update_attributes(params[:profile_setting].permit!)
		# response to the JSON
			render json: { success: true,message: "Residency deploma Successfully Updated.", response: {residency_diploma: @user.residency_diplomas.map(&:text)} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_spe_training
		if @user.update_attributes(params[:profile_setting].permit!)
		# response to the JSON
			render json: { success: true,message: "spe_training Successfully Updated.", response: {spe_training: @user.spe_trainings.map(&:text)} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	def update_award
		if @user.update_attributes(params[:profile_setting].permit!)
		# response to the JSON
			render json: { success: true,message: "Awards Successfully Updated.", response: {awards: @user.awards.map(&:text)} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end
	end

	# Method for creating the updating the my hobbies params
	def update_my_hobbies
	 	if @user.update_attributes(my_hobby: params[:my_hobby])
	 	# response to the JSON
			render json: { success: true,message: "My hobby Successfully Updated.", response: {my_hobby: @user.my_hobby} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end

	# Method for updating the my favorites page
	def update_my_favorites
		if @user.update_attributes(my_favorite: params[:my_favorite])
		# response to the JSON
			render json: { success: true,message: "My favorites Successfully Updated.", response: {my_favorite: @user.my_favorite} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end

	# Method for updating the my quote page params
	def update_my_quote
		if @user.update_attributes(my_quote: params[:my_quote])
	    # response to the JSON
			render json: { success: true,message: "My quote Successfully Updated.", response: {my_quote: @user.my_quote} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end

	# Method for updating the about me page 
	def update_about_me
	    if @user.update_attributes(about_text: params[:about_text])
		# response to the JSON
			render json: { success: true,message: "About me Successfully Updated.", response: {about_me: @user.about_text} },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end

	# Method for updating the speciality and sub speciality names
	def update_specialist
		 # update the speciality name ans sub speciality
		if @user.update_attributes(specialist_name:params[:specialist_name],sub_speciality_name:params[:sub_speciality_name])
		 # response to the JSON
			render json: { success: true,message: "Specialist Successfully Updated.", response: {specialist_name: @user.specialist_name.as_json,sub_speciality_name:@user.sub_speciality_name.as_json } },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end
    
    # Method for updating the profile setting images
	def update_profile_photo
		# update the profile update images like cover photo and profile photo
		 if @user.update_attributes(profile_image: params[:profile_image],cover_image: params[:cover_image])
		# response to the JSON
			render json: { success: true,message: "Profile photo Successfully Updated.", response: {cover_image: @user.cover_image.as_json, profile_image: @user.profile_image.as_json } },:status=>200
	    else
	        render :json=> { success: false, message: @user.errors },:status=> 203
	    end	
	end

	def update_passcode
		user = current_user
		if user.update_attributes(passcode: params[:passcode])
        # response to the JSON
		  render json: { success: true,message: "Passcode Successfully Updated.", response: {passcode: user.passcode} },:status=>200
	    else
	      render :json=> { success: false, message: user.errors },:status=> 203
	    end
    end

    # Method for listing the all the surgery name list
	def surgery_name_list
		surgeries = current_user.surgeries
		if surgeries.present?
		# response to the JSON
      	  render json: { success: true, response: {surgeries: surgeries.collect(&:name).as_json } },:status=> 200
	    else
	      render :json=> { success: false, message: "Surgeries are not present" },:status=> 203
	    end 
	end

	# Method for listing the all the diagnose name list
	def diagnosis_name_list
		diagnose = current_user.diagnose
		if diagnose.present?
		# response to the JSON
      	  render json: { success: true, response: {diagnose: diagnose.collect(&:name).as_json } },:status=> 200
	    else
	      render :json=> { success: false, message: "Diagnosis are not present" },:status=> 203
	    end 
	end

	private

	# Method for Finding the particular profile for the surgeon
	def find_profile
		# Find particular Profile 
		@profile = Profile.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Profile ID !'}, status: 400 if @profile.nil?
	end

	# Method for Find the all surgery location for the profile surgeon
	def find_surgery_location
		# Find the surgeon location based on the profile
		@surgery_locations = current_user.setting.surgery_locations.all
	end


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

	def profile_setting
		# Condition for checking the profile setting exits for surgeon
		if current_user.profile_setting.blank?
			#Initialize profile setting for surgeon
			profile_setting = current_user.build_profile_setting
			# Saving profile setting information for surgeon
			profile_setting.save
		else
			#Fetch  profile setting information for surgeon
			@profile_setting = current_user.profile_setting
		end
	end

    # fins the user setting
	def find_user_setting
		# find the user setting
		@user = current_user.profile_setting
	end

end
