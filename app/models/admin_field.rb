class AdminField
  include Mongoid::Document
  include Mongoid::Timestamps

  field :field_name,type: String
  field :field_slug,type: String
  field :field_type,type: String
  field :required,:type => Boolean, :default => false
  field :multiple,:type => Boolean, :default => false

  embeds_many :field_options

  accepts_nested_attributes_for :field_options, allow_destroy: true

end
