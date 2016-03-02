class Api::CaseNotesController < Api::BaseController
  # Find the particular case note before method
	before_action :find_case_note,only: [:update]
	# Before action find the case id
	before_action :find_case, only: [:create,:update]
    # Before action check params
	before_action :check_parameter,:only=>[:create,:update]

	# Method for creating the case note form 
	def create
		# Create the note for that particular case
		case_note = @case.case_notes.new(case_note_params)
		case_note.user_id = current_user.id

		if case_note.save
    	# response to the JSON
    	render json: { success: true,message: "Case Note Successfully Created.", response: CaseNoteSerializer.new(case_note).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: case_note.errors },:status=> 203
	    end
	end

	# Method for updating the notes with particular case note
	def update
		#check condition for present or not.
		if @case_note.present?
			# updating the case note attributes for the particular case note
		  @case_note.update_attributes(case_note_params)
		  #response in json format
	      render json: { success: true,message: "Case Note Successfully Updated.", response: CaseNoteSerializer.new(@case_note).as_json(root: false) },:status=>200
	    else
	      render :json=> { success: false, message: "Notes are not present" },:status=> 203
	    end 
	end

	private

	# Method permitting the case note params
	def case_note_params
		# Permitting the case note parameters to the particular case
		params.require(:case_note).permit(:note)
	end

    # Method for the find the paricular case 
	def find_case
		# Find the case 
		@case = Case.where(id:params[:case_id])[0]
		render json: {success: false, message: 'Invalid Case ID !'}, status: 400 if @case.nil?
	end

	# Method for the find the paricular case note
	def find_case_note
		# Find the case notes
		@case_note = CaseNote.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Case Note ID !'}, status: 400 if @case_note.nil?
	end

	def check_parameter
      #check params
      render json: {success: false, message: 'Missing params !'}, status: 400 if params[:case_note].blank?
    end

end
