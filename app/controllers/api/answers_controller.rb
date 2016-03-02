class Api::AnswersController < Api::BaseController
	# Before action find the question id
	before_action :find_question, only: [:create]
	respond_to :json

    # Creating the answer for the question
	def create
		# creating answer to the question
		answer = @question.answers.create(answer_text:params[:answer_text],poll:params[:poll],user_id:current_user.id)
		if !params[:file].nil?
			# Creating the loop for storing the each and every image with answer
			params[:file].each do |a|
				# storing the image with answer
				answer_attachment = answer.answer_media_attachments.create!(:attachment => a)
			end
		end
		# checking answer is save or not
		if answer.save
	  	# response to the JSON
	  		render :json=> {success: true,message: "Answer Successfully Created.", "answer" => answer.as_json }
	  	else
	    	render :json=> { success: false, message: answer.errors },:status=> 203
	  	end
	end

private
	#Finding question by id
    def find_question
    	@question = Question.where(id:params[:question_id])[0]
		render json: {success: false, message: 'Invalid Question ID !'}, status: 400 if @question.nil?
	end 
end
