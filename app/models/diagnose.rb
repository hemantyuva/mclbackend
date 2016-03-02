class Diagnose
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,type: String
  field :user_type,type: String

  belongs_to :user
  belongs_to :case
  
end
