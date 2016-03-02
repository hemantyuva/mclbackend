class CaseMediaAttachment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::TagsArentHard

  before_save :get_content_type

  before_create :check_media_size_limit

  scope :last_week, ->{ where(:created_at=>(Time.now-14.days)..(Time.now-7.days)) }
  scope :last_month, ->{ where(:created_at=>(1.month.ago.beginning_of_month)..(1.month.ago.end_of_month)) }
  scope :last_year, ->{ where(:created_at=> (1.year.ago.beginning_of_year)..(1.year.ago.end_of_year)) }

  scope :video, ->{ where(:attachment_type =>"video") }
  scope :audio, ->{ where(:attachment_type => "audio" ) }
  scope :image, ->{ where(:attachment_type => "image" ) }

  default_scope -> { order_by(:created_at => :asc) }

  field :note,type: String
  field :location,type: String
  field :upload_status,type: Boolean,:default => true
  field :attachment_type, type: String

  taggable_with :tags

  mount_uploader :attachment, CaseImageUploader

  belongs_to :case_medium

  def as_json(options={})
    super(except: [:id,:created_at, :updated_at, :case_medium_id,:confirm_media])
    {
      :id => self.id,
      :case_media_attachments => self.case_medium.case_media_attachments.all.collect{|x| x.attachment if x.case_medium_id!=nil}.compact,
      :note => self.note,     
      :tags => self.tags
     }
  end

  def get_content_type
    self.attachment_type = attachment.content_type.split("/")[0]
  end


  def check_media_size_limit
    user_id = CaseMedium.find(self.case_medium_id).user_id
    user = User.find(user_id)
    if user.setting.media_upload.try(:media_upload_limit)
      size_limit = user.setting.media_upload.media_upload_limit.to_i 
      self.attachment.size <= size_limit*1024*1024
    end
  end

end
