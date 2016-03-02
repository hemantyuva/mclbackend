class AdminForm
  include Mongoid::Document
  include Mongoid::Timestamps

  field :form_type, type: String
  field :form_name,type: String
  field :form_name_slug,type: String
  field :form_fields, type: Array, default:[]
end
