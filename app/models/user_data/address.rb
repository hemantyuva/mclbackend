class UserData::Address
  include Mongoid::Document
  include Mongoid::Timestamps
  field :address_location, type: String
  field :address_type, type: String
  validates_presence_of :address_location
  embedded_in :profile_setting , class_name: "ProfileSetting"
end
