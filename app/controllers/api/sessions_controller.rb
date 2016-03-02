class Api::SessionsController < Devise::SessionsController
  
  skip_before_filter :authenticate_user!, only: [:create]  
  skip_before_filter :verify_authenticity_token, :has_passcode? ,only: [:create]
  before_filter :verify_parameter, only: [:create]
  before_filter :verify_token, only: [:verify_number,:destroy]
  #authorize_resource :class => :controller
  def create
    email = params[:user][:email]
    password = params[:user][:password]    
    user = User.where( email: email.downcase )[0]

    if user.blank?
      render :json=>{status: false, :message=>"Invalid email or passoword."}, :status=>400
      return

    elsif !user.valid_password?(password)
      render :json=>{status: false, message: "The request must contain the user email and password."}, :status=>400
      return

    else
      generate_token user
      if user.admin==true
        sign_in("user", user)
        render json: { success: true,message: "You sucessfully logged in", response: UserSerializer.new(user).as_json(root: false) },:status=>200
        return
      else
        send_miscall user  
        sign_in("user", user)
        render json: { success: true,message: "You sucessfully logged in, please enter last 5 digit OTP code of missed call to proceed further", response: UserSerializer.new(user).as_json(root: false) },:status=>200
        return
      end

    end  

  end  
 
  def destroy
    current_user.update(:authentication_token => nil)
    associate = Associate.where(id:params[:associate_id])[0]
    associate.update_attributes(associate_user: false) if !associate.nil?
    if sign_out(:user)
      render :json=> {:success=>true, :message=>"Sign Out Sucessfully"}
    else
      render :json=> {:success=>false, :message=>"Error with your email or password"}
    end
  end

  def verify_number   
    if !session[:otp_match].nil?
      validate_otp

      if validate_otp
        render json: { success: true,message: "You sucessfully verified your number." },:status=>200
        return
      else
        render json: { success:  session[:opt_response]["status"] ,message: session[:opt_response]["errors"].values[0] }, :status=>session[:opt_response]["errors"].keys[0]
        return
      end
    else
      uri = URI.parse("https://www.cognalys.com/api/v1/otp/confirm/?app_id=#{Rails.application.secrets["cognalys"]["app_id"]}&access_token=#{Rails.application.secrets["cognalys"]["access_token"]}&keymatch=#{session[:otp_match]}&otp=#{session[:otp_match]}#{params[:otp]}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      data = http.get(uri.request_uri)
      response = JSON.parse(data.body)

      render json: { success: false,message: response },:status=>305
      return
    end  

  end

#method for verifying token
  def verify_token
    #checking signed_in user
    if user_signed_in?
      #checking token is nil or not.
      if params[:token].nil?
        #response in json format
        render :json=> { success: false, message: "Token is required to proceed further." },:status=> 203
        return
      #checking token with the current_user
      elsif current_user.authentication_token != params[:token]
        render :json=> { success: false, message: "Problem with the authentication token.please check token." },:status=> 203
        return
      else
      end
    end
  end

  private

    def user_params
      params[:user].permit!
    end

    def verify_parameter

      if params[:user][:email].nil? and params[:user][:password].nil?
        render :json=>{status: false, message: "The request must contain the user email and password."}, :status=>400
        return
      end      

    end


  def validate_otp
    Rails.logger.info params
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
      if current_user.passcode.nil?
        render :json=> { success: false, message: "Please create your passcode" },:status=> 203
        return
      end

    end
  end
 
  def generate_token resource
    token = SecureRandom.hex(10)
    resource.update(:authentication_token=>token)
  end

end 

