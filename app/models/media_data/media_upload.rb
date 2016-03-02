class MediaData::MediaUpload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :media_upload_limit,type: String

  embedded_in :setting , class_name: "Setting"
  
end