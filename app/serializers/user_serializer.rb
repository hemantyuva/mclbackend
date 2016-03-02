class UserSerializer < BaseSerializer
  attributes :id, :email, :mobile, :name, :location,:authentication_token
end