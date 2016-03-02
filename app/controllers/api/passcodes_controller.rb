class Api::PasscodesController < Api::BaseController
  skip_before_filter :has_passcode?, only: [:create]
  before_action :get_user
  before_action :get_passcode

  def create
    if User.check_size_passcode(params[:passcode])
      @user.passcode  = params[:passcode]
      @user.save
      render json: { success: true, message: "Passcode successfully created." },:status=>200
      return
    else
      render json: { success: true, message: "Passcode should be of four digits" },:status=>200
      return
    end
  end

  def match_passcode
    if User.check_passcode(@user,params[:passcode])
      render json: { success: true, message: "Passcode successfully matched." },:status=>200
      return
    else
      render json: { success: true, message: "Failed to match,please try again." },:status=>200
      return
    end
  end

  private
    def get_user
      @user = User.where( id: params[:user_id] )[0]
      if @user.nil?
        render :json=> { success: false, message: "problem with the user ID" },:status=> 404
        return
      end
    end

    def get_passcode
      if params[:passcode].blank?
        render :json=> { success: false, message: "Passcode is missing." },:status=> 404
        return
      end
    end
end