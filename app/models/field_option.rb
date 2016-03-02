class FieldOption
  include Mongoid::Document
  field :option_text, type: String
  field :default_option, :type => Boolean, :default => false
  
  embedded_in :admin_field
  embedded_in :user_field
end
