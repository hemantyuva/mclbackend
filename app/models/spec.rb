class Spec
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::MultiParameterAttributes


  field :diagnosis, type: Array, default: []
  field :surgery, type: Array, default: []
  


  def diagnosis_list=(arg)
    self.diagnosis = arg.split(',').map { |v| v.strip }
  end

  def diagnosis_list
    self.diagnosis.join(', ')
  end
  
  embedded_in :speciality , :inverse_of => :specs
end
