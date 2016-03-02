class SessionsController < Devise::SessionsController
	# after action need to count the login
	after_action :login_count,only: [:create]
	# before action need to count no of users login 
	before_action :login_count,only: [:destroy]
	# before action need to check the user status
	before_action :user_status,only: [:create]


	# Method for customize the user login session 
	def create
		# Find the Particular Login User
		resource = warden.authenticate!(auth_options)
		# If Admin type is Present then that is navigate to the admin root page
		if resource.admin == true
			# Navigate to the admin root page
			redirect_to dashboard_admin_index_path
		else
			# Navigate to the Surgeon root page
			redirect_to root_url
		end
	end	

	def destroy
		super
	end

	private

	def login_count
		params[:action] == "create" ? current_user.update(login_status: 1) : current_user.update(login_status: 0)
	end

	def user_status
		resource = warden.authenticate!(auth_options)
		if resource.status == false
			destroy
			flash.notice = "Your Account has been blocked"
		end
	end
end