class UserFormDatum
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :case
  belongs_to :user
end
