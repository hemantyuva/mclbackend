class QuestionMediaAttachment
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :image, ImageUploader

  belongs_to :question
  
  	def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :question_id])
	end
end
