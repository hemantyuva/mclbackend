class Api::VotesController <  Api::BaseController
	# Before action find the question id
  before_action :set_question , only: [:create, :destroy]
	# Before action find the answer id
  before_action :set_answer , only: [:create_answer_votes, :destroy_answer_votes]
  # Before action find the vote id
  before_action :destroy_votes, only: [:destroy,:destroy_answer_votes]
  
   # Method for creating the vote for question
	def create
		if @question.vote_not_present?(current_user)
      vote = @question.votes.new
      vote.user = current_user
    end
    if vote.save
      render json: { success: true,message: "Vote has Successfully Created."},:status=>200
    else
      render :json=> { success: false, message: "Questions are not present" },:status=> 203
    end
	end

  # Method for destory the vote for question
	def destroy
		if @vote.destroy
  		# response to the JSON
  		render json: { success: true,message: "Vote Successfully Deleted."},:status=>200
    	return
	    else
	      render :json=> { success: false, message: "Vote is not available" },:status=> 404
	    	return
	    end
	end

	# Method for creating the vote for anwser
	def create_answer_votes
		if @answer.vote_not_present?(current_user)
      vote = @answer.votes.new
      vote.user = current_user
    end
    if vote.save
      render json: { success: true,message: "Vote Successfully Created."},:status=>200
    else
      render :json=> { success: false, message: "Answers are not present" },:status=> 203
    end
	end

  # Method for destroy the vote for anwser
	def destroy_answer_votes
		if @vote.destroy
		# response to the JSON
		render json: { success: true,message: "Vote Successfully Deleted."},:status=>200
  	return
    else
      render :json=> { success: false, message: "Vote is not available" },:status=> 404
    	return
    end
	end

	private
  	
    # Method for finding the particular vote with id
    def destroy_votes
    	@vote = Vote.where(id:params[:id])[0]
      render json: {success: false, message: 'Invalid Vote ID !'}, status: 400 if @vote.nil?
  	end

    # Method for finding the particular question with id
  	def set_question
	 		@question = Question.where(id:params[:question_id])[0]
      render json: {success: false, message: 'Invalid Question ID !'}, status: 400 if @question.nil?
  	end

    # Method for finding the particular answer with id
  	def set_answer
    	@answer = Answer.where(id:params[:answer_id])[0]
      render json: {success: false, message: 'Invalid Ansser ID !'}, status: 400 if @answer.nil?
  	end

end
