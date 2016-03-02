class AdminController < ApplicationController
	# Calling the Admin layout for all the methods
	layout "admin"
	# Before action need to find the list
	before_action :find_list,only: [:dashboard]
	# Before action need to find the user
	before_action :find_user,only: [:user_status,:user_profile,:reset_password,:password_update]
	# Before action need to find the user type
	before_action :check_user
	
	# Method for list out the users,patients and cases
	def dashboard
	end

	# Method for search the user according to the keyword
	def search_user
		# Find the keyword and match with user data
		@users = find_search_term(params[:searchterm])
			# render the js file to replace the data
			respond_to do |format|
				format.js
			end
	end


	# Method for the list out the all the users
	def manage_user
		# All the users with each page 20 records
		@users = User.paginate(page: params[:page],per_page: 10)
	end

	# Method for finding the particular user
	def user_profile
	end

	# Method for checking the user is enable or disable
	def user_status
		# Checking the If User status is false then enable
		if @user.status == false
			# Update the field as true
			 @user.update(status: 1)
		## Checking the If User status is true then disable
		elsif @user.status == true
			# Update the field as false
			 @user.update(status: 0)
		end
		# Redirect to the same page of enable and disable button page
		redirect_to :back
	end

	# Method for reset password of the surgeon from admin 
	def reset_password
	end

	# Update the passworc of the particular surgeon
	def password_update
		# Update the user password attributes	
		@user.update(user_params)
		# After updating the password redirect to the manager user page
		redirect_to manage_user_admin_index_path
	end

	def select_user_status
		# Find the keyword and match with user data
		@users = find_status_term(params[:statusterm])
		# render the js file to replace the data
		respond_to do |format|
			format.js
		end
	end

 private

	def user_params
		params.require(:user).permit(:password,:password_confirmation)
	end
	
	# Method for find list of the users,patients and cases
	def find_list
		# List of the user
		@users = User.all
		# List of the patients
		@patients = Patient.all
		# List of the cases
		@cases = Case.all
		# Count the no of user are logged into the site
		@loggedin_count = User.where(login_status: 1).count
  end

	# Method for finding the particular user
	def find_user
		# Find the User 
		@user = User.find(params[:id])
	end

	# Method for finding the particular keyword from name or mobile
	def find_search_term searchterm
		User.any_of(
			{ :name => /^#{searchterm}/i },
			{ :mobile => /^#{searchterm}/i }) 
	end

	def find_status_term statusterm
		statusterm == "true" ? User.any_of({:status => 1}) : User.any_of({:status => 0})
	end

end