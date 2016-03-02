class Preferrence
  include Mongoid::Document
  include Mongoid::Timestamps


  embedded_in :user
  
  field :assistants,type: Array, default: []
  field :anaesthetists,type: Array, default: []
  field :user_created_diagnosis,type: Array, default: []
  field :user_created_surgery,type: Array, default: []
  field :saved_search,type: Array, default: []


end

