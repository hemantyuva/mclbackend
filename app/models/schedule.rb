class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps
 	
  after_save :update_surgery_date_to_case
  after_create :update_surgery_date

  field :schedule_date, type: DateTime
  belongs_to :surgery_location


  belongs_to :case


  def update_surgery_date_to_case
  	schedule_case = self.case 
  	schedule_case.schedule_date = schedule_date
  	schedule_case.touch
  end


  def update_surgery_date
    schedule_case = self.case 
    schedule_case.surgery_date = schedule_date
    schedule_case.touch
  end

  def as_json(options={})
    super(except: [:id,:created_at, :updated_at, :case_id,:surgery_location])
    {
      :schedule_date => self.schedule_date
      }
  end
end
