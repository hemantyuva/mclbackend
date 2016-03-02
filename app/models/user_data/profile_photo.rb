# class UserData::ProfilePhoto
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   mount_uploader :cover_image, ProfileImageUploader
#   mount_uploader :profile_image, ProfileImageUploader
  
#   embedded_in :profile_setting , class_name: "ProfileSetting"

# end
