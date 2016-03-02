class Answer
	include Mongoid::Document
	include Mongoid::Timestamps
	
	field :answer_text, type: String
	field :votes_count, type: Integer, default: 0
	field :poll, type: String

	belongs_to :question, counter_cache: true
	belongs_to :user

	has_many :answer_media_attachments,dependent: :destroy

	has_many :votes, as: :voteable, dependent: :destroy
  
  	accepts_nested_attributes_for :answer_media_attachments

  	def vote_present?(user)
		!votes.where(:user_id =>user.id).first.blank?
	end

	def vote_not_present?(user)
		votes.where(:user_id =>user.id).first.blank?
	end


	def as_json(options={})
		{
			:question => self.question.title,
			:id => self.id,
			:title => self.answer_text,
			:question_created_at => self.question.created_at.strftime("%B  %d, %Y"),
			:answer_count => self.question.answers.count,
			:poll => self.poll,
			:answer_media_attachments => self.answer_media_attachments
		}
	end

end

