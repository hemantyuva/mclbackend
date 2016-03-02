class UserFormSerializer < BaseSerializer
	attributes :id, :field_name, :field_slug, :field_type, :required,:multiple,:field_options
end