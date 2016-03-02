class CaseMedium
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessor :validation_code, :flash_notice
  # scop for listing patient for owner and user
  scope :owned, lambda { |owner_id| 
    (self.where(:owner_id.in=>[owner_id,self.all.selector["user_id"]])) if owner_id.to_s!=self.all.selector["user_id"].to_s
  }
  # After Create Need to crete activity for that casemedia
  after_create :case_activity
  # Before create need to count no of selected attachement for case media
  before_create :media_attachment_count
  # Before Update need to count no of selected attachement for case media
  before_update :media_attachment_count

  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :case


  has_many :case_activities, as: :activeable, dependent: :destroy

  has_many :case_media_attachments ,dependent: :destroy

  accepts_nested_attributes_for :case_media_attachments
  

  # Method for Counting the Attachment for that case media
  def media_attachment_count
    self.case_media_attachments.try(:count) <= 10
  end

  # Creating the Activity for the Case Medium after creating case media
  def case_activity
    self.case_activities.create(case_id: self.case_id,user_id: self.user_id,owner_id:self.owner_id)
  end

  def as_json(options={})
	  super(except: [:id,:created_at, :updated_at, :case_id,:user_id])
	  {
      :id => self.id,
      :case_media_attachments => self.case_media_attachments
      }
	end
end
