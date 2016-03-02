class AnswersController < ApplicationController
  # Before action need to find the user type
  before_action :check_admin
  # before action need to check the session time out
  before_action :check_max_session_time
  # before action need to check the user is existed or not
  before_action :find_logged_user
	
	# Creating the answer for the question
	def create
		# Finding the particular question id
		question = Question.find(params[:question_id])
		# creating answer to the question
		answer = question.answers.create(answer_params)
		# checking the answer attachment present or not
		if !params[:answer_attachment].nil?
			# Creating the loop for storing the each and every image with answer
			params[:answer_attachment][:image].each do |a|
				# storing the image with answer
				answer_attachment = answer.answer_media_attachments.create!(:image => a)
			end
		end
		# redirect to the paticular question show page
		redirect_to :back
	end

private
	
	def answer_params
		# Permitting the answer attribues
		params.require(:answer).permit(:answer_text,:user_id,:poll)
	end
	
end