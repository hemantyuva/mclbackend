class Api::SurgeryLocationsController < Api::BaseController
	# before action need to find the setting
	before_action :setting, only:[:create]
	# before need to find the surgery loation
	before_action :find_location,only: [:update]

	def create
		if params[:url] == "schedule"
			# if the params is coming from the schedule the permit the only name attributes
			@surgery_location = current_user.setting.surgery_locations.create(name: params[:name])
		else
			# Method for surgeon creating the new surgerylocation 
			surgery_location = current_user.setting.surgery_locations.create(surgery_location_params)
			if surgery_location.save
			# response to the JSON
			  render json: { success: true,message: "Surgery Location Successfully Created.", response: SurgeryLocationSerializer.new(surgery_location).as_json(root: false) },:status=>200
		    else
		      render :json=> { success: false, message: surgery_location.errors },:status=> 203
		    end
		end
	end

	# Method for listing out the all the surgery locations
	def index
		surgery_locations = SurgeryLocation.all
		if surgery_locations.present?
	    # response to the JSON
	      render json: { success: true, response: surgery_locations.map{ |f| SurgeryLocationSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Surgery Location is not present." },:status=> 203
	    end 
	end

	# Method for updating the surgery form
	def update
		# updating the surgery location attribute
		if @surgery_location.update(surgery_location_params)
		# response to the JSON
			render json: { success: true,message: "Surgery Location Successfully Updated.", response: SurgeryLocationSerializer.new(@surgery_location).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: "Surgery Location is not available" },:status=> 404
	    end
	end

private
	def surgery_location_params
		params.require(:surgery_location).permit(:name,:address,:phone)
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

	# Method for finding the particular surgery location
	def find_location
		@surgery_location = SurgeryLocation.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Surgery Location ID !'}, status: 400 if @surgery_location.nil?
	end
end
