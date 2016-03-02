class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout :layout_by_resource # Responsible for main layout 

  acts_as_token_authentication_handler_for User

  #disabled the default CSRF protection for JSON requests 
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :html, :json
  before_action :set_associate_user

  rescue_from CanCan::AccessDenied do |exception|
    if !user_signed_in?
      redirect_to new_user_session_url
      flash[:notice] = "Please login to continue"
    else
      redirect_to root_url
    end
  end

  # Method for using different layout for devise controllers 
  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  alias_method :devise_current_user, :current_user

  def current_user
    if session[:surgeon_id].blank? && params[:surgeon_id].blank?
      session[:current_user] = devise_current_user
    else !session[:surgeon_id].blank? || !params[:surgeon_id].blank?
      session[:surgeon_id] = params[:surgeon_id] || session[:surgeon_id]
      User.find(session[:surgeon_id]) rescue session[:surgeon_id]=nil
    end
  end

  # Method for checking the current user admin or surgeon
  def check_admin
      # condition for checking the current user
     if user_signed_in? && devise_current_user.admin?
      # if current user as admin then navigate to the dashboard page
       redirect_to dashboard_admin_index_path
     end
  end

  # Method for checking the current user admin or surgeon
  def check_user
    # condition for checking the current user
    unless devise_current_user.admin?
      # if current user is as surgeon then navigate to the patients index page
      redirect_to root_url
    end
  end

  # Method for checking the max session time the surgeon asigned
  def check_max_session_time
    # Method for checking the user is logged or not
    if devise_current_user.setting
      timeout = devise_current_user.setting.session_max
       if %w(24 48).include?(timeout)
        if devise_current_user.current_sign_in_at + timeout.to_i.hours < Time.now
          sign_out :user
        end
      end
    end
  end

  # Method for checking the user is logged in to the site or not
  def find_logged_user
    # condition for if current user is not logged in to the site
    if !devise_current_user
      # redirect to the session new page(login page)
      redirect_to new_user_session_path
      # showing the flash notice 
      flash.notice = "Session has been expired, Please login to continue"
    end
  end

  # Method for find associate user
  def set_associate_user
    session[:associate_id] = session[:associate_id] || params[:associate_id]
    @associate = Associate.find(session[:associate_id]) rescue nil if session[:associate_id]
    if (session[:associate_id] && @associate.nil?)
      sign_out devise_current_user
      redirect_to new_user_session_path
    end
    session[:edit_right] = @associate.try(:edit_right)
  end

  def after_sign_in_path_for(resource)
    session[:surgeon_id] = nil
    session[:edit_right] = nil
    session[:associate_id] = nil
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
  
  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    session[:surgeon_id] = nil
    session[:edit_right] = nil
    session[:associate_id] = nil
    root_path
  end
end
  