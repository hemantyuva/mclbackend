class Associate
  include Mongoid::Document
  field :recipient_email, type: String
  field :recipient_mobile, type: Integer
  field :status, type: Boolean
  field :edit_right, type: Boolean, :default => false
  field :associate_user, type: Boolean, :default => false

  validates_presence_of :recipient_email

  belongs_to :invitee, :class_name => 'User'
  belongs_to :user


  def as_json(options={})
    {
      :id => self.id,
      :name => self.invitee.name,
      :recipient_email => self.recipient_email,
      :recipient_mobile => self.recipient_mobile,
      :status => self.edit_right
    }
  end
end
