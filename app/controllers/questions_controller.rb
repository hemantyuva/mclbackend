class QuestionsController < ApplicationController
	# Before action find the question id
	before_action :find_question, only: [:post,:show, :edit,:show_question_tags,:destroy_question_media]
	# Before action find the all the questions
	before_action :questions_list, only: [:index,:question_list]
	# Before action find the question id
	before_action :set_question_media, only: [:destroy_question_media]
	# Before action need to find the user type
	before_action :check_admin
	# before action need to check the session time out
	before_action :check_max_session_time
	# before action need to check the user is existed or not
	before_action :find_logged_user
	# before action need to count no of tags limit
	before_action :count_tags,only: [:post,:update,:edit]
	# before action need to count no of question tags limit
	before_action :question_tag_count,only: [:update]
	# before action need to find the user 
	before_action :set_associate_user
  	
	# Method for initialize question form
	def new
		@question = Question.new
		# respond to the html file
		respond_to do |format|
			format.html do
				render "new", layout: false
			end
		end
	end

	# Method for creating the question
	def create
		# Finding the current surgeon 
		surgeon = devise_current_user
		# creating the question with current surgeon
		question = surgeon.questions.create(ask_question_params)
		# redirect to the paticular question show page
		redirect_to post_question_path(question)
	end

	def edit
		
	end

	# Method for post the question after asking question
	def post
		# listing all tags for question 
		@tags = Question.all_tags
	end

	# Method for list out all the question created by surgeon
	def index
		if !params[:tag].nil?
		# Get tag name for params
			@tag = params[:tag]
		# Listing the all the questions related to the tag
			@questions = Question.with_all_tags(params[:tag]).paginate(page: params[:page],per_page: 5)
		end # condition end
	end
	
	# Method for listing the questions
	def question_list
		respond_to do |format|
			format.js
		end
	end

	# Method for list out all the question related to current surgeon
	def my_scn
		@questions = devise_current_user.questions.all
		respond_to do |format|
			format.html do
				render "my_scn", layout: false
			end
			format.js
		end
	end
	
	# Method for list out current surgeon answers 
	def my_scn_answers
		@answers = devise_current_user.answers.all
		respond_to do |format|
			format.html do
				render "my_scn_answers", layout: false
			end
		end
	end

	# Method for update the question details with question ask
	def update
		#Find the paticular question id
		question = Question.find(params[:question_id])
		#Condition for checking the scn tag and scn tags both equal or not
		if @scn_tag_count <= @scn_tag_limit
			# Update the attributes question with question id
			question.update_attributes(post_question_params)
			# Condition for validating the nil error for media attachments
		  	if !params[:question_attachment].nil?
				# created loop for storing images
				params[:question_attachment][:image].each do |a| 
					# creating the individual images for that particular question
					question_attachment = question.question_media_attachments.create!(:image => a)
				end
			end
			# redirect to question list page
			redirect_to questions_path
		else
			# if both not equal then showing the flash notice
			flash.notice = "Tag limit for question is not more that "+@scn_tag_limit.to_s+" tags"
			# redirect to the same page of the question post page
			redirect_to :back
		end
	end

	# Method for showing the particular Question 
	def show
	# Listing the all the answers related to the questions
		@answers = @question.answers
	# Intialize the answer to particular question
		@answer = Answer.new
	# Initialize answer media fiels to the particular answer
		@answer_attachments  = @answer.answer_media_attachments.build
	end

	# Method for showing the most answers Question
	def most_answers_questions
		@questions = Question.most_answers_questions
		respond_to do |format|
			format.html do
				render "most_answers_questions", layout: false
			end
		end
	end

	# Method for showing the most votes Question
	def most_votes_questions
		@questions = Question.most_votes_questions
		respond_to do |format|
			format.html do
				render "most_votes_questions", layout: false
			end
		end
	end

	# Method for showing the SCN users
	def scn_users
		@users = User.all.paginate(page: params[:page],per_page: 5)
		if params[:page].nil?
			respond_to do |format|
				format.js
			end
		end
	end

	# Method for showing the tags for particular question
	def show_question_tags
		respond_to do |format|
		  format.js
		end
	end

	# Method for the search question tags while creating the questions
	def search_tags
		# Searching for patients as per user entered term
		question_tags = Question.all_tags.select{|p| p=~/^#{params[:term]}/i }.uniq.to_json
		respond_to do |format|
		  format.json { render :json => question_tags }
		end
	end

	# Method for the destroy the question media
	def destroy_question_media
		@question_media.destroy
		respond_to do |format|
		  format.js
		end
	end

	def show_filter_options
		respond_to do |format|
			format.html do
				render "show_filter_options", layout: false
			end
		end
	end

private
	# Permitting the question attributes
	def ask_question_params
		# permitting the media attachment with question
		params.require(:question).permit(:title)
	end
	
	# Permitting the post question attributes
	def post_question_params
		params.require(:question).permit(:content, :tags, options_attributes: [:id, :text, :_destroy])
	end

	# Method for finding the particular question with id
	def find_question
		@question = Question.find(params[:id])
	end 

	# Method for listing the questions
	def questions_list
		# list out the question details
		@questions = Question.all.order_by(:created_at=> :desc).paginate(page: params[:page],per_page: 5)
	end

	# Method for finding the particular media with id
	def set_question_media
		@question_media = QuestionMediaAttachment.find(params[:media_id])
	end

	# Method for checking the no of scn tag limt
	def count_tags
		# checking the the scn tags is existed or not
		if devise_current_user.setting
			# Count the no of scn tag limit for the each question from setting
			@scn_tag_limit = devise_current_user.setting.scn_tag_limit.to_i
		end
	end

	# count the no of tag limit for the questions
	def question_tag_count
		# find the params of question tags
		tags = params[:question][:tags]
		# count the no of tags for that particular question
		@scn_tag_count = tags.split(",").count
	end

	def set_associate_user
		@associate_user = devise_current_user
	end
end