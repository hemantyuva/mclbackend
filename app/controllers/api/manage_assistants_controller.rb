class Api::ManageAssistantsController < Api::BaseController
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to check the manage assistant
	before_action :find_manage_assistant,only: [:update,:destroy]

	# Method for creating the manage associates for the particular surgeron
	def create
		# creating the manage assistance parameter
		manage_assistant = current_user.manage_assistants.new(name: params[:name])
		if manage_assistant.save
    	# response to the JSON
	    	render json: { success: true,message: "Manage Assistant Successfully Created.", response: ManageAssistantSerializer.new(manage_assistant).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: manage_assistant.errors },:status=> 203
	    end
	end

	# Method for updating the manage associates for the particular surgeron
	def update
		# updating the particular manage assistant
		if @manage_assistant.update(name: params[:name])
		# response to the JSON
			render json: { success: true,message: "Manage Assistant Successfully Updated.", response: ManageAssistantSerializer.new(@manage_assistant).as_json(root: false) },:status=>200
	    else
	        render :json=> { success: false, message: @manage_assistant.errors },:status=> 203
	    end
	end

	# Method for destroying the particular manage assistant
	def destroy
		# destroy the particular manage assistant
		if @manage_assistant.destroy
		# response to the JSON
			render json: { success: true,message: "Manage Assistant Successfully Deleted." },:status=>200
	    else
	        render :json=> { success: false, message: "Manage Assistant is not present." },:status=> 203
	    end

	end

	# Method for listing the all the assistance name
	def index
		manage_assistants = current_user.manage_assistants.all
		if manage_assistants.present?
	      render json: { success: true, response: manage_assistants.map{ |f| ManageAssistantSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Manage Assistant are not present" },:status=> 203
	    end
	end

private

	# Method for find the manage assistant
	def find_manage_assistant
		# find the particular manage assistant
		@manage_assistant = ManageAssistant.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Manage Assistant ID !'}, status: 400 if @manage_assistant.nil?
	end
end
