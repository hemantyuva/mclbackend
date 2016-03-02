class Api::QuestionsController < Api::BaseController
	# Before action Get the all the question related to the current surgeon
	before_action :surgeon_questions, only: [:my_scn,:my_scn_answers]
	# Before action find the question id
	before_action :find_question, only: [:show,:update]
	# Before action find the question id
	before_action :set_question_media, only: [:destroy_question_media]
	# before action need to check the count of tags setting
	before_action :count_tags,only: [:update]
	# before action need to check the count of current tags
	before_action :current_tags_count,only: [:update]
  	respond_to :json

	def index
	# list out the question details
    questions = Question.all
  	#checking question is present or not.
    if questions.present?
    	# response to the JSON
    	render :json=> {success: true, "question" => questions.as_json('question_data') }
    else
      render :json=> { success: false, message: "Questions are not present" },:status=> 203
    end

	end

  # Method for creating the question
	def create
	# Finding the current surgeon 
	surgeon = current_user
	# creating the question with current surgeon
	question = surgeon.questions.new(question_params)
	if question.save
	# response to the JSON
		render json: { success: true,message: "Question Successfully Created.", response: QuestionSerializer.new(question).as_json(root: false) },:status=>200
    else
      render :json=> { success: false, message: question.errors },:status=> 203
    end
	end

	# Method for showing the particular Question 
	def show
    # show the particular question
	if @question.present?
		# response to the JSON
		render :json=> {success: true, "question" => @question.as_json('question_show') }
    else
      render :json=> { success: false, message: "Questions are not present" },:status=> 203
    end
	end

	# Method for update the question details with question ask
	def update
		if current_tags_count <= count_tags
			# Update the attributes question with question id
			@question.update_attributes(content:params[:content],tags:params[:tags])
			@question.options.destroy_all if !@question.question_media_attachments.blank?
			@question.options.create!(text:params[:text])
			# Condition for validating the nil error for media attachments
		    if !params[:file].nil?
				# created loop for storing images
				@question.question_media_attachments.destroy_all if !@question.question_media_attachments.blank?
				params[:file].each do |image| 
					# creating the individual images for that particular question
					question_attachment = @question.question_media_attachments.create!(:image => image)
				end
			end
			# checking question is save or not
			if @question.save
		  	# response to the JSON
		  		render :json=> {success: true,message: "Question Successfully Updated.", "question" => @question.as_json('question_update') }
		  	else
		    	render :json=> { success: false, message: @question.errors },:status=> 203
		  	end
		else
			render :json=> { success: false, message: "only #{count_tags} tags allowed"},:status=> 404
	    	return
		end
	end

  # Method for showing the question according to answer descending order
	def most_answers_questions
		questions = Question.most_answers_questions
		#checking questions is present or not.
		if questions.present?
    	render :json=> {success: true, "question" => questions.as_json("question_data") }
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	def most_votes_questions
		questions = Question.most_votes_questions
		#checking questions is present or not.
		if questions.present?
    	render :json=> {success: true, "question" => questions.as_json("question_data") }
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	# Method for showing questions of a single Tag
	def single_tag_questions
	# Listing the all the questions related to the tag
		questions = Question.with_all_tags(params[:tag])
		#checking questions is present or not.
		if questions.present?
    	render :json=> {success: true, "question" => questions.as_json("question_data") }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	# Method for list out all the question related current surgeon
	def my_scn
	    if @questions.present?
			# response to the JSON
			render json: { success: true, "questions" => @questions.as_json('my_scn') }
	    else
	      render :json=> { success: false, message: "Questions are not present" },:status=> 203
	    end
	end

	# Method for list out current surgeon answers 
	def my_scn_answers
		#collect all the answers of current user
	  answers = current_user.answers.all.map(&:question).uniq
		if answers.present?
		# response to the JSON
		render :json=> {success: true, "answers" => answers.as_json('my_scn_answers')}
	    else
	      render :json=> { success: false, message: "Answers are not present" },:status=> 203
	    end
	end

	# Method for list of all User
	def scn_users
		users = User.all
		#checking users is present or not.
	    if users.present?
	    	render :json=> {success: true, "users" => users.as_json('question_data') }
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Users are not present" },:status=> 203
	    end
	end

	# Method for destroy of questions attachment
	def destroy_question_media
		if @question_media.destroy
		# response to the JSON
		render json: { success: true,message: "Image deleted successfully" },:status=>200
		else
		render :json=> { success: false, message: @question_media.errors },:status=> 203
		end
	end


# Method for the search question tags while creating the questions
	def search_tags
		# Searching for patients as per user entered term
		question_tags = Question.all_tags.select{|p| p=~/^#{params[:term]}/i }.uniq
		if question_tags.present?
	    	render :json=> {success: true, "Tags" => question_tags.as_json }
	      # render json: { success: true, response: @questions.map{ |f| QuestionSerializer.new(f).as_json( root: false ) } }
	    else
	      render :json=> { success: false, message: "Tags are not present" },:status=> 203
	    end
	end

private
	# Permitting the questions attributes 
    def question_params
      params.require(:question).permit(:title)
    end

  #Finding question by id
    def find_question
		@question = Question.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Question ID !'}, status: 400 if @question.nil?
	end 

	# Method for list out the all the question related to surgeon
	def surgeon_questions
		@questions = current_user.questions.all
	end

	# Method for finding the particular media with id
	def set_question_media
		@question_media = QuestionMediaAttachment.where(id:params[:id])[0]
		render json: {success: false, message: 'Invalid Question Media Attachment ID !'}, status: 400 if @question_media.nil?
	end

	def current_tags_count
		params[:tags].count if params[:tags]
	end

	def count_tags
		# checking the setting media tags is there or not
		if current_user.setting
			# count the media tag count id more than 0
			if current_user.setting.media_tag_limit.to_i > 0
				# count limit for that media attachment tag
				@tag_count = current_user.setting.scn_tag_limit.to_i
			end
		end
	end

end
