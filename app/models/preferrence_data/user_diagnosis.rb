# class PreferrenceData::UserDiagnosis
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   field :user_created_diagnosis,type: Array, default: []

#   embedded_in :preferrence , class_name: "Preferrence"

# end