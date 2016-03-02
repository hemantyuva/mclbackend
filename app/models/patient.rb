class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  # scop added for search by patient name
  scope :search_by_name, lambda { |q|
    any_of({ :firstname => /^#{q}/i })
  }

  # scop for listing patient for owner and user
  scope :owned, lambda { |owner_id| 
    (self.where(:owner_id.in=>[owner_id,self.all.selector["user_id"]])) if owner_id.to_s!=self.all.selector["user_id"].to_s
  }

  default_scope -> { order_by(:created_at => :asc) }

  field :firstname, type: String
  field :lastname, type: String
  field :gender, type: String
  field :dob, type: Date
  field :email, type: String
  field :phone, type: Integer

  validates_presence_of :firstname, :lastname, :gender,:dob

  GENDER_TYPES = ["Male","Female"]

  belongs_to :user
  belongs_to :owner, class_name: "User"
  
  has_many :cases,dependent: :destroy

  def as_json(options={})
    { mydetail: 
      {
        :id => self.id,
        :firstname => self.firstname,
        :phone => self.phone,
        :lastname => self.lastname,
        :email => self.email,
        :dob => self.dob,
        :gender => self.gender
      },
      mysergeries: {
        :cases => self.cases
      },
      misc_media: {
        :created_at => self.created_at,
        :misc_media => self.cases.map(&:case_media).flatten.map(&:case_media_attachments).flatten.map{|attachment| attachment.attachment if attachment.attachment_type=='image'}.compact
      }
    }
  end


  def full_name
    "#{firstname} #{lastname}".upcase
  end
  
  def icon
    ActionController::Base.helpers.asset_url(gender=="Male" ? 'icons/m.png' : 'icons/f.png')
  end
end
