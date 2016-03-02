class ManageAssistantsController < ApplicationController
  # Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to check the manage assistant
	# before_action :find_manage_assistant,only: [:edit,:update,:destroy]
	before_action :preferrence
	before_action :set_associate_user

	
	# Method for initializing the manage assistance form
	def new
		 @assistant = devise_current_user.build_preferrence
	end

	def create_assistants
		devise_current_user.preferrence.assistants  << params[:preferrence][:assistants]
		devise_current_user.preferrence.save
		redirect_to manage_assistants_path
	end

	def index
		@manage_assistants = devise_current_user.preferrence.assistants
	end

	def edit_assistants

	end

	def anaesthetists
		@anaesthetist = devise_current_user.build_preferrence
	end

	def create_anaesthetists
		devise_current_user.preferrence.anaesthetists << params[:preferrence][:anaesthetists]
		devise_current_user.preferrence.save
		redirect_to anaesthetists_list_manage_assistants_path
	end



	def anaesthetists_list
		@anaesthetists = devise_current_user.preferrence.anaesthetists
	end



	# Method for edit the particular manage assistant 
	# def edit
	# end



	# # Method for creating the manage associates for the particular surgeron
	# def create
	# 	# creating the manage assistance parameter
	# 	manage_assistant = devise_current_user.manage_assistants.create(manage_assistance_params)
	# 	# rediect to the manage assistance index page
	# 	redirect_to manage_assistants_path
	# end

	# Method for updating the manage associates for the particular surgeron
	# def update
	# 	# updating the particular manage assistant
	# 	@manage_assistant.update(manage_assistance_params)
	# 	# rediect to the manage assistance index page
	# 	redirect_to manage_assistants_path
	# end

	# Method for destroying the particular manage assistant
	# def destroy
	# 	# destroy the particular manage assistant
	# 	@manage_assistant.destroy
	# 	# redirect to the same page of the manage assistants
	# 	redirect_to :back
	# end

	# Method for listing the all the assistance name


private
	
	# # Permitting the manage assistance params
	# def manage_assistance_params
	# 	# permitting attributes
	# 	params.require(:manage_assistant).permit(:name)
	# end

	# # Method for find the manage assistant
	# def find_manage_assistant
	# 	# find the particular manage assistant
	# 	@manage_assistant = ManageAssistant.find(params[:id])
	# end

	def preferrence
		# Condition for checking the profile setting exits for surgeon
		if devise_current_user.preferrence.blank?
			#Initialize profile setting for surgeon
			preferrence = devise_current_user.build_preferrence
			# Saving profile setting information for surgeon
			preferrence.save
		else
			#Fetch  profile setting information for surgeon
			@preferrence = devise_current_user.preferrence
		end
	end

	def set_associate_user
		@associate_user = devise_current_user
	end

end
