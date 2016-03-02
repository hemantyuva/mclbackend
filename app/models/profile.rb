class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :speciality_name, type: String
  field :sub_speciality_name, type: String
  field :medical_school,type: String
  field :residency,type: String
  field :spe_training, type: String
  field :my_favourite,type: String
  field :my_hobby,type: String
  field :more_about,type: String

  mount_uploader :cover_image, ImageUploader
  mount_uploader :profile_image, ImageUploader


  belongs_to :setting

  SPECIALITY_TYPES = ["Orthopedics Surgery","Knee arthroplasty", "Arms Surgery"]
  SUB_SPECIALITY_TYPES = ["Hip and Knee arthroplasty"]
  
    def as_json(options={})
      super(except: [:id,:created_at, :updated_at])
      {
        :speciality_name => self.speciality_name,
        :sub_speciality_name => self.sub_speciality_name,
        :medical_school => self.medical_school,
        :residency => self.residency,
        :spe_training => self.spe_training,
        :my_favourite => self.my_favourite,
        :my_hobby => self.my_hobby,
        :more_about => self.more_about,
        :cover_image => self.cover_image,
        :profile_image => self.profile_image,
        :username => self.setting.user.name,
        :questions => self.setting.user.questions.collect(&:title),
        :surgery_locations => self.setting.user.surgery_locations.all
      }
    end

end
