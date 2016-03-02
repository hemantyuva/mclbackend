class Setting
  include Mongoid::Document
  include Mongoid::Timestamps

  field :session_max,type: String
  field :type_app_color,type: String
  field :media_tag_limit,type: String
  field :scn_tag_limit,type: String

  embeds_one :media_upload, class_name: "MediaData::MediaUpload"

  belongs_to  :user
  has_many :surgery_locations
  has_one :profile
  accepts_nested_attributes_for :surgery_locations

end
