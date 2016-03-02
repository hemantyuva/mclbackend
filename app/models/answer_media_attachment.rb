class AnswerMediaAttachment
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :image, ImageUploader
  
  belongs_to :answer

  	def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :answer_id])
	end

end