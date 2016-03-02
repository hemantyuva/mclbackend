class Api::SurgeriesController < Api::BaseController

  skip_before_filter :verify_user,:has_passcode?

  #Method for showing all the surgery list
  def index
    surgeries = Surgery.all
    if surgeries.present?
      # response to the JSON
        render json: { success: true, response: surgeries.map{ |f| SurgerySerializer.new(f).as_json( root: false ) } }
      else
        render :json=> { success: false, message: "Surgery is not present." },:status=> 203
      end 
  end

end
