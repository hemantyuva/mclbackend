class Api::BaseController < ApplicationController

  respond_to :json
  before_filter :verify_user,:has_passcode?
  before_filter :verify_token
  #authorize_resource :class => :controller
  
  def default_serializer_options
    {
      root: false
    }
  end

  def verify_user

    if user_signed_in?
  		# if session[:opt_response].nil?
  		# 	render :json=> { success: false, message: "Your mobile number is not verified" },:status=> 203
  		# 	return

  		# elsif  session[:opt_response]["status"] == "failed"
  		# 	render :json=> { success: false, message: "Your mobile number is not verified" },:status=> 203
  		# 	return
  		# end
    end  

  end

  #method for verifying token
  def verify_token
    associate = Associate.where(id: params[:associate_id])[0] if params[:associate_id]
    #checking signed_in user
    if user_signed_in?
      #checking token is nil or not.
      if params[:token].nil?
        #response in json format
        render :json=> { success: false, message: "Token is required to proceed further." },:status=> 203
        return
      elsif associate && associate.associate_user == true
        return true
      #checking token with the current_user
      elsif current_user.authentication_token != params[:token]
        render :json=> { success: false, message: "Problem with the authentication token.please check token." },:status=> 203
        return
      else
      end
    end
  end
 
  def current_user
    associate = Associate.where(id: params[:associate_id])[0] if params[:associate_id]
    if associate && associate.associate_user == true
      user = User.where(id:associate.invitee_id)[0]
      return user
    else
      user = User.where(authentication_token:params[:token])[0]
      return user
    end
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

  def has_passcode?
    if user_signed_in?      
      # if current_user.passcode.nil?
      #   render :json=> { success: false, message: "Please create your passcode" },:status=> 203
      #   return
      # end
    end
  end
end