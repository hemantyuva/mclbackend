# class PreferrenceData::Assistant
#   include Mongoid::Document
#   include Mongoid::Timestamps

#   field :assistant_name,type: Array, default: []

#   embedded_in :preferrence , class_name: "Preferrence"

# end