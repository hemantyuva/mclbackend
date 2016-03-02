class Option
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :question

  def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :question_id])
	end
end
