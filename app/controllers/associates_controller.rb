class AssociatesController < ApplicationController
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to find associate
	before_action :set_associate,only: [:accept,:reject,:destroy,:show,:update_edit_right]

	def index
		@associates=devise_current_user.associates
	end

	def associate_users
		@associates = Associate.where(recipient_email: devise_current_user.email,status: true)
	end

	def add
		@associate = Associate.new
	end

	def create
		@associate = Associate.new(invitation_params)
	    @associate.invitee = devise_current_user
	    if @associate.save
	        UserMailer.invitation(@associate, new_user_registration_url).deliver_now
	        flash[:notice] = "Invite sent successfully"
	    else
	      flash[:notice] =  "Invite failed"
	    end
	    redirect_to :back
	end

	def create_invitation
		@user = User.find(params[:user_id])
		@associate = devise_current_user.associates.find_or_initialize_by(recipient_email: @user.email)
	    @associate.recipient_mobile = @user.mobile
	    @associate.status = nil
	    if @associate.save
	        flash[:notice] = "Invite sent successfully"
	    else
	      flash[:notice] =  "Invite failed"
	    end
	    redirect_to :back
	end

	def user_invitations
		@invitations = Associate.where(recipient_email: devise_current_user.email,status: nil)
	end

	def show
		@user = User.find(params[:user_id])
	end

	def accept
  		@associate.update_attributes(status: true,user_id: devise_current_user.id)
    	redirect_to settings_path
	end

	def reject
		@associate.update_attributes(status: false,user_id: devise_current_user.id)
		redirect_to settings_path
	end

	def update_edit_right
		@associate.update_attributes(edit_right: params[:value])
		# respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
	end

	def search_user
		# Search users according to the keyword
		@users =User.any_of({:email =>params[:searchterm]},{:mobile => params[:searchterm]}).not_in(:_id => devise_current_user.id) 
		# respond_to the the js file
	    respond_to do |format|
	      format.js
	    end
	end

	def destroy
		@associate.destroy
		redirect_to associates_path
	end
	
	private

	def set_associate
	    # Finding the particular associate
	    @associate = Associate.find(params[:id])
 	end

    def invitation_params
      params.require(:associate).permit(:recipient_email,:recipient_mobile)
    end
end
