class CaseActivity
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope -> { order_by(:created_at => :desc) }

  belongs_to :case
  belongs_to :user
  belongs_to :owner, class_name: "User"

  belongs_to :activeable , polymorphic: :true

end
