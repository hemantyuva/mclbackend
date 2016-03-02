class Cases::CaseNotesController < ApplicationController
	# Find the particular case before method
	before_action :find_case,only: [:index,:new,:edit]
	# Find the particular case note before method
	before_action :find_case_note,only: [:edit,:update]
	# Before action need to find the user type
  	before_action :check_admin
  	# before action need to check the session time out
  	before_action :check_max_session_time
  	# before action need to check the user is existed or not
  	before_action :find_logged_user


	# Method for initialize the Case Media Form
	def new
		# Initialize the case note form
		@case_note = CaseNote.new
	end

	# Method for creating the case note form 
	def create
		params[:case_note][:owner_id] = devise_current_user.id.to_s
		# Create the note for that particular case
		case_note = current_user.case_notes.create(case_note_params)
		if params[:user_followup_form_id].present?
	 		user_form = UserForm.find(params[:user_followup_form_id])
	 		case_note.user_form = user_form
	 		case_note.user_form_fields = user_form.form_fields.to_a
	 		case_note.user_form_data = params[:fields]
	 	end
 		case_note.save
		redirect_to case_case_media_path
	end

	# Method for editing the case note form
	def edit

	end

	# Method for updating the notes with particular case note
	def update
		params[:case_note][:owner_id] = devise_current_user.id.to_s
		# updating the case note attributes for the particular case note
		@case_note.update_attributes(case_note_params)
		@case_note.user_form_data = params[:fields]
 		@case_note.save
		#redirect to the cases index page after update the case notes
		redirect_to case_case_media_path
	end

	private

	# Method permitting the case note params
	def case_note_params
		# Permitting the case note parameters to the particular case
		params.require(:case_note).permit(:note,:case_id,:owner_id)
	end

	# Method for finding the particular case
	def find_case
		# Find the particular case
		@surgery_case = Case.find(params[:case_id])
	end

	# Method for the find the paricular case note
	def find_case_note
		# Find the case notes
		@case_note = CaseNote.find(params[:id])
	end

end