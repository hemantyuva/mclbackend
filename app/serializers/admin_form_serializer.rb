class AdminFormSerializer < BaseSerializer
  #list of json attributes
  attributes :id, :form_name, :form_name_slug, :form_fields
end