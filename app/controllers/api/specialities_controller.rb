class Api::SpecialitiesController < Api::BaseController

  skip_before_filter :verify_user,:has_passcode?

  #Method for collecting all speciality
  def index
    specialities = Speciality.all
    if specialities.present?
    # response to the JSON
      render json: { success: true, response: specialities.map{ |f| SpecialitySerializer.new(f).as_json( root: false ) } }
    else
      render :json=> { success: false, message: "Speciality is not present." },:status=> 203
    end 
  end

end
