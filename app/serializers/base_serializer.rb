# The base serializer imposes a generic structure for all api responses
class BaseSerializer < ActiveModel::Serializer
  # Disable the root element
  self.root = false
end

