class Case
	include Mongoid::Document
	include Mongoid::Timestamps
	scope :last_week, ->{ where(:created_at=>(Time.now-14.days)..(Time.now-7.days)) }
	scope :oldest, ->{ order_by(:created_at => :asc) }
	scope :latest, ->{ order_by(:created_at => :desc) }
  # scop for listing cases for owner and user
  scope :owned, lambda { |owner_id| 
    (self.where(:owner_id.in=>[owner_id,self.all.selector["user_id"]])) if owner_id.to_s!=self.all.selector["user_id"].to_s
  }

  after_create :create_surgery
  after_create :create_diagnose
  after_update :update_surgery
  after_update :update_diagnose

	field :diagnose_name, type: String
	field :surgery_name, type: String
  field :side, type: String
  field :schedule_date, type: DateTime
  field :surgery_date, type: DateTime

  field :assistant_name, type: Array, default: []
  
  # User form fields
  field :user_form_fields, type: Array, default: []
  # User form data
  field :user_form_data, type: Hash, default: {}

  belongs_to :patient
  belongs_to :user
  belongs_to :owner, class_name: "User"

	has_many :case_media
	has_many :case_notes
	has_many :case_activities
  belongs_to :user_form
  has_one :schedule, dependent: :destroy
  # has_many :manage_assistants

  accepts_nested_attributes_for :schedule
  # accepts_nested_attributes_for :manage_assistants, allow_destroy: true


    # Method for creating the surgery name after creating schedule
    def create_surgery
      # creating the entry for the surgery as user
      Surgery.create(name: self.surgery_name,user_id: self.user_id,user_type: "user",case_id: self.id)
      user = User.find(self.user_id)
      user.preferrence.user_created_surgery << self.surgery_name
      user.preferrence.save
    end

    # Method for creating diagnose name after creating the schedule
    def create_diagnose
      # creating the entry for the diagnose as user
      Diagnose.create(name: self.diagnose_name,user_id: self.user_id,user_type: "user",case_id: self.id)
      user.preferrence.user_created_diagnosis << self.diagnose_name
      user.preferrence.save
    end

    # Method for updating the surgery name according to the case
    def update_surgery
      # update the surgery name 
      Surgery.where(case_id: self.id).update(name: self.surgery_name)
    end

    # Method for updating the diagnose name according to the case
    def update_diagnose
       # update the diagnose name 
      Diagnose.where(case_id: self.id).update(name: self.diagnose_name)
    end

    def as_json(type, options={})
    super(except: [:id, :updated_at, :user_id, :patient_id])
    data = 
    if (type == "case_media_index")
      {
      :entries => self.case_media.count + self.case_notes.count,
      :media => self.case_media.count,
      :note => self.case_notes.count,
      :case_media => self.case_media,
      }
    elsif (type == "case_show")
      {
      :entries => self.case_media.count + self.case_notes.count,
      :media => self.case_media.count,
      :note => self.case_notes.count,
      :surgery_name => self.surgery_name,
      :side => self.side,
      :schedule_date => self.schedule_date,
      :user_form_fields => self.find_field,
      :user_form_data => self.user_form_data
      }
    else
      {
      :surgery_name => self.surgery_name,
      :schedule_date => self.schedule
      }
    end.merge({
      :id => self.id,
      :patient => self.patient.firstname + " " + self.patient.lastname,
      :created_at => self.created_at.strftime("%B  %d, %Y"),
      :diagnose_name => self.diagnose_name
      })
    data
  end

  def form_value(key)
    user_form_data[key] rescue nil
  end
  
  def find_field
    UserField.find(self.user_form_fields)
  end

end