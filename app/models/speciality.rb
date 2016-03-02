class Speciality
  include Mongoid::Document
  include Mongoid::Timestamps
  
  default_scope -> { order_by(:name => :asc) }

  field :name, type: String

end
