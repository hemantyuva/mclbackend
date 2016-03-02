class ProfileSetting
  include Mongoid::Document
  include Mongoid::Timestamps

  field :specialist_name, type: String
  # field :sub_speciality_name,type: String

  mount_uploader :cover_image, ProfileImageUploader
  mount_uploader :profile_image, ProfileImageUploader

  field :home_phone,type: Integer
  field :work_phone,type: Integer
  field :my_hobby,type: String
  field :my_favorite,type: String
  field :my_quote,type: String
  field :about_text,type: String

  embeds_many :addresses , class_name: "UserData::Address"
  embeds_many :high_schools , class_name: "UserData::HighSchool"
  embeds_many :medical_schools, class_name: "UserData::MedicalSchool"
  embeds_many :residency_diplomas , class_name: "UserData::ResidencyDiploma"
  embeds_many :spe_trainings , class_name: "UserData::SpeTraining"
  embeds_many :awards , class_name: "UserData::Award"
  embeds_many :sub_speciality_names , class_name: "UserData::SubSpecialityName"
  embeds_many :speciality_names , class_name: "UserData::Address"
  
  embedded_in :user

  
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :high_schools, allow_destroy: true
  accepts_nested_attributes_for :medical_schools, allow_destroy: true
  accepts_nested_attributes_for :residency_diplomas, allow_destroy: true
  accepts_nested_attributes_for :spe_trainings, allow_destroy: true
  accepts_nested_attributes_for :awards, allow_destroy: true
  accepts_nested_attributes_for :sub_speciality_names, allow_destroy: true

end

