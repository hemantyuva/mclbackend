class VotesController < ApplicationController
	# Before action find the question id
  before_action :set_question , only: [:create_question_votes, :destroy_question_votes]
	# Before action find the answer id
  before_action :set_answer , only: [:create_answer_votes, :destroy_answer_votes]
  # Before action find the vote id
  before_action :destroy_votes, only: [:destroy_question_votes,:destroy_answer_votes]
  # Before action need to find the user type
  before_action :check_admin
  # before action need to check the session time out
  before_action :check_max_session_time
  # before action need to check the user is existed or not
  before_action :find_logged_user
  # before action need to find the user 
  before_action :set_associate_user

  # Method for creating the vote for question
	def create_question_votes
		if @question.vote_not_present?(devise_current_user)
      @vote = @question.votes.new
      @vote.user = devise_current_user
      @vote.save
    end
	end

  # Method for destory the vote for question
	def destroy_question_votes
	end

  # Method for creating the vote for anwser
	def create_answer_votes
		if @answer.vote_not_present?(devise_current_user)
      @vote = @answer.votes.new
      @vote.user = devise_current_user
      @vote.save
    end
	end

  # Method for destroy the vote for anwser
	def destroy_answer_votes
		
	end

	private
  	# Use callbacks to share common setup or constraints between actions.
  	
    # Method for finding the particular vote with id
    def destroy_votes
    	@vote = Vote.find(params[:id])
      @vote.destroy
  	end

    # Method for finding the particular question with id
  	def set_question
	 		@question = Question.find(params[:question_id])
  	end

    # Method for finding the particular answer with id
  	def set_answer
    	@answer = Answer.find(params[:answer_id])
  	end

    def set_associate_user
      @associate_user = devise_current_user
    end
end