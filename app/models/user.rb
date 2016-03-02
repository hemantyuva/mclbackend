class User
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope -> { order_by(:name => :asc) }
  validates_uniqueness_of :mobile
    ## Token Authenticatable
  acts_as_token_authenticatable
  field :authentication_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :mobile,             type: String, default: ""
  field :recent_search_term, type: Array, default: []
  field :question_recent_search_term, type: Array, default: []
  field :media_recent_search_term, type: Array, default: []
  field :graph_search_term, type: Array, default: []
  field :scn_score ,type: Integer, default: 0
  field :activation,type: Boolean

  #Register
  field :name,               type: String, default: ""
  field :admin, :type => Boolean, :default => false
  field :primary_surgeon_id, type: String, default: ""
  field :location, type: String, default: ""

  ## Custom Fields
  field :status,:type => Boolean, :default => true
  field :login_status,:type => Boolean, :default => false
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :passcode, type: Integer
  # field :passcode,           type: Integer

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  #Subscription 
  field :subscribed, :type => Boolean, :default => false
  field :stripeid,   :type => String
  field :renewal_date, :type => DateTime

  def admin?
    admin
  end

  def self.check_passcode(user,passcode)
    user.passcode == passcode.to_i ? true : false
  end

  def self.check_size_passcode(passcode)
    passcode.size == 4 ? true : false
  end

  def as_json(options={})
    {
      :id => self.id,
      :name => self.name,
      :email => self.email,
      :mobile_no => self.mobile,
      :status => self.status
    }
  end

  has_many :cases
  has_many :patients
  has_many :surgery_locations
  has_many :questions
  has_many :answers
  has_many :votes
  has_one  :setting
  has_many :searches
  has_many :case_media
  has_many :case_notes
  has_many :surgeries
  has_many :manage_assistants
  has_many :diagnose
  has_many :user_fields
  has_many :user_forms
  has_many :associates, :class_name => 'Associate', :foreign_key => 'invitee_id'
  
  embeds_one :profile_setting

  embeds_one :preferrence

  accepts_nested_attributes_for :profile_setting

  accepts_nested_attributes_for :preferrence

end

