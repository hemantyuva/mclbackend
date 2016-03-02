class AdminFieldSerializer < BaseSerializer
  #list of json attributes
  attributes :id, :field_name, :field_slug, :field_type
end