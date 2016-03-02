class Search
 include Mongoid::Document
 include Mongoid::Timestamps

 field :search_term, type: String
 
 field :type, type: String

 belongs_to  :user

 	def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :user_id])
	end

end
