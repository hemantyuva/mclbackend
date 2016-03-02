class CaseNote
  include Mongoid::Document
  include Mongoid::Timestamps

  # After Creating Case Note Need to create the Activity for that note
  after_create :case_activity
  
  scope :owned, lambda { |owner_id| 
    (self.where(:owner_id.in=>[owner_id,self.all.selector["user_id"]])) if owner_id.to_s!=self.all.selector["user_id"].to_s
  }

  default_scope -> { order_by(:created_at => :asc) }

  field :note,type: String
  # User form fields
  field :user_form_fields, type: Array, default: []
  # User form data
  field :user_form_data, type: Hash, default: {}
  
  has_many :case_activities, as: :activeable, dependent: :destroy
  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :case
  belongs_to :user_form

  # Creating the Activity for Particular Case Note
  def case_activity
    self.case_activities.create(case_id: self.case_id,user_id: self.user_id,owner_id:self.owner_id)
  end

  default_scope -> { order_by(:created_at => :asc) }


  def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :case_id,:user_id])
	  {
      :username => self.user.name,
      :note => self.note
    }
	end

  def form_value(key)
    user_form_data[key] rescue nil
  end
  
end
