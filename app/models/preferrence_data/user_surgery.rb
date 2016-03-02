# class PreferrenceData::UserSurgery
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   field :user_created_surgery,type: Array, default: []

#   embedded_in :preferrence , class_name: "Preferrence"

# end