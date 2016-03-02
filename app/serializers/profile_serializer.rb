class ProfileSerializer < BaseSerializer
  #list of json attributes
  attributes :id, :speciality_name, :sub_speciality_name, :medical_school, :residency, :spe_training, :my_favourite, :my_hobby, :more_about,:cover_image, :profile_image
end