class UserData::SubSpecialityName
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  embedded_in :profile_setting , class_name: "ProfileSetting"
end
