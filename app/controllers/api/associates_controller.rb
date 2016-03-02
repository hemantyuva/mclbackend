class Api::AssociatesController < Api::BaseController
	before_action :find_user,only: [:show]
	# before action need to find associate
	before_action :set_associate,only: [:accept,:reject,:destroy,:show,:update_edit_right,:start_associate_session]
    
    def start_associate_session
    	if @associate.update_attributes(associate_user: true)
	    	render json: { success: true, message: "Associate session has started" },:status=>200
	    else
	    	render :json=> { success: false, message: "Associate user is not available" },:status=> 203
	    end
    end

    def index
		associates=devise_current_user.associates
		if associates.present?
			render json: { success: true, response: associates.as_json },:status=>200
		else
		    render :json=> { success: false, message: associates.errors },:status=> 203
		end
	end

	def associate_users
		associates = Associate.where(recipient_email: devise_current_user.email,status: true)
		if associates.present?
			render json: { success: true, response: associates.as_json },:status=>200
		else
		    render :json=> { success: false, message: associates.errors },:status=> 203
		end
	end

	def create
		associate = Associate.new(invitation_params)
	    associate.invitee = devise_current_user
	    if associate.save
	    	UserMailer.invitation(associate, new_user_registration_url).deliver_now
	    	render json: { success: true,message: "Invite sent successfully.", response: AssociateSerializer.new(associate).as_json(root: false) },:status=>200
	    else
	    	render :json=> { success: false, message: "Invite failed" },:status=> 203
	    end
	end

	def create_invitation
		user = User.find(params[:user_id])
		associate = devise_current_user.associates.find_or_initialize_by(recipient_email: user.email)
	    associate.recipient_mobile = user.mobile
	    associate.status = nil
	    if associate.save
	    	render json: { success: true,message: "Invite sent successfully.", response: AssociateSerializer.new(associate).as_json(root: false) },:status=>200
	    else
	    	render :json=> { success: false, message: "Invite failed" },:status=> 203
	    end
	end

	def user_invitations
		invitations = Associate.where(recipient_email: devise_current_user.email,status: nil)
		if invitations.present?
			render json: { success: true, response: invitations.as_json },:status=>200
		else
		    render :json=> { success: false, message: invitations.errors },:status=> 203
		end
	end

	def show
		render json: { success: true, response: {email:@user.email.as_json,mobile:@user.mobile.as_json} },:status=>200
	end

	def accept
  		if @associate.update_attributes(status: true,user_id: devise_current_user.id)
    	# response to the JSON
		  render json: { success: true,message: "Invitation has accepted Successfully."},:status=>200
	    else
	      render :json=> { success: false, message: "Associate is not available" },:status=> 404
	    end
	end

	def reject
		if @associate.update_attributes(status: false,user_id: devise_current_user.id)
        # response to the JSON
		  render json: { success: true,message: "Invitation has rejected Successfully."},:status=>200
	    else
	      render :json=> { success: false, message: "Associate is not available" },:status=> 404
	    end
	end

	def update_edit_right
		if @associate.update_attributes(edit_right: params[:value])
		# response to the JSON
		  render json: { success: true,message: "Update edit right Successfully."},:status=>200
	    else
	      render :json=> { success: false, message: "Associate is not available" },:status=> 404
	    end
	end

	def search_user
		# Search users according to the keyword
		users =User.any_of({:email =>params[:searchterm]},{:mobile => params[:searchterm]}).not_in(:_id => devise_current_user.id) 
		if users.present?
			render json: { success: true, response: users.as_json },:status=>200
		else
		    render :json=> { success: false, message: users.errors },:status=> 203
		end
	end

	def destroy
		if @associate.destroy
		# response to the JSON
  		render json: { success: true,message: "Associate Successfully Deleted."},:status=>200
	    else
        render :json=> { success: false, message: "Associate is not available" },:status=> 404
        end
	end
	
	private

	def set_associate
	    # Finding the particular associate
	    @associate = Associate.where(id: params[:id])[0]
	    render json: {success: false, message: 'Invalid Associate ID !'}, status: 400 if @associate.nil?
 	end

 	def find_user
 		# Find particular Profile 
 	# 	@user = User.where(id: params[:user_id])[0]
		# render json: {success: false, message: 'Invalid User ID !'}, status: 400 if @user.nil?
 	end

    def invitation_params
      params.require(:associate).permit(:recipient_email,:recipient_mobile)
    end

end
