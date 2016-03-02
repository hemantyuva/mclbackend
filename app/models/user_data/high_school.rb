class UserData::HighSchool
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  validates_presence_of :text
  embedded_in :profile_setting , class_name: "ProfileSetting"
end
