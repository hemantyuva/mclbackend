class UserForm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :form_type, type: String
  field :form_name,type: String
  field :form_name_slug,type: String
  field :form_fields, type: Array, default:[]
  validates_uniqueness_of :form_name

  has_many :cases
  has_many :case_notes 
  belongs_to :user
end
