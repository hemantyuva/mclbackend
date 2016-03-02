class Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :about_content,type: String
  field :faq_content,type: String
  field :contact_address,type: String
  field :contact_number,type: String
  field :email,type: String

   def as_json(type, options={})
    data =  
    case type
      when 'about'
      {
       :content => self.about_content
     }
     when 'faq' 
      {
      :content => self.faq_content
      }
     when 'contact' 
      {
      :contact_address => self.contact_address,
      :contact_number => self.contact_number,
      :email => self.email
      }
    end.merge({
      :id => self.id
    })
    data
  end
  
  # validates_presence_of :contact_number

end
