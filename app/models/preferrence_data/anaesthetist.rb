# class PreferrenceData::Anaesthetist
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   field :anaesthetist_name,type: Array, default: []

#   embedded_in :preferrence , class_name: "Preferrence"

# end