class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, only: [:create]
  skip_before_filter :verify_authenticity_token, :verify_user, :has_passcode?
  require "open-uri"

  def create
    resource = User.new(sign_up_params) #build resource for initalizing user
    # Verifying otp as per user entered information if resource is valid    
     
    if resource.valid? && !session[:otp_match].nil? && params[:otp].present? && validate_otp
      resource.save # Saving user information fter otp verification
      resource.primary_surgeon_id = resource.id
      resource.save
      sign_in resource  # User sign in 
      render json: { success: true,message: "You sucessfully create your account please create your passcode to proceed further.", response: UserSerializer.new(resource).as_json(root: false) },:status=>200
      return

    elsif !resource.valid?
      render :json=> { success: false, message: resource.errors },:status=> 203
      return

    elsif !session[:otp_match].nil? && params[:otp].present? && !validate_otp
      render :json=> { success:  session[:opt_response]["status"], message: session[:opt_response]["errors"].values[0] },:status=> session[:opt_response]["errors"].keys[0]
      return

    elsif !params[:otp].present? || session[:otp_match].nil? 
      send_miscall resource
      if session[:otp_match]["status"] == "failed"
        render :json=> { success:  session[:otp_match]["status"], message: session[:otp_match]["errors"].values[0] },:status=> session[:otp_match]["errors"].keys[0]
        return
      else
        render :json=> { success:  session[:otp_match]["status"], message: "Please enter a last 5 digit number of missed call number." },:status=> 200
        return
      end  

    end

  end  

  private

    def sign_up_params
      params[:user].permit!
    end

  def validate_otp

    uri = URI.parse("https://www.cognalys.com/api/v1/otp/confirm/?app_id=#{Rails.application.secrets["cognalys"]["app_id"]}&access_token=#{Rails.application.secrets["cognalys"]["access_token"]}&keymatch=#{session[:otp_match]["keymatch"]}&otp=#{session[:otp_match]["otp_start"]}#{params[:otp]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    data = http.get(uri.request_uri)
    response = JSON.parse(data.body)
    session[:opt_response] = response
    return (response["status"] == "success") ? true : false

  end

  def send_miscall resource    

    @uri = URI.parse("https://www.cognalys.com/api/v1/otp/?app_id=#{Rails.application.secrets["cognalys"]["app_id"]}&access_token=#{Rails.application.secrets["cognalys"]["access_token"]}&mobile=#{resource.mobile}")
    uri=Net::HTTP.get(@uri)
    json_uri=JSON.parse(uri)
    session[:otp_match] = json_uri

  end

end 