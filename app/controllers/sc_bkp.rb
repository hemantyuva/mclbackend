class SessionsController < Devise::SessionsController
  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/sessions_controller.rb

  # POST /resource/sign_in
  # Resets the authentication token each time! Won't allow you to login on two devices
  # at the same time (so does logout).

    layout 'empty'
  prepend_before_filter :require_no_authentication, only: [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, only: :create
  prepend_before_filter :verify_signed_out_user, only: :destroy
  prepend_before_filter only: [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }

   def create
   self.resource = warden.authenticate!(auth_options)
   sign_in(resource_name, resource)
 
   current_user.update authentication_token: nil



   respond_to do |format|
   
     format.json {
       render :json => {
         :user => current_user,
         :status => :ok,
         :authentication_token => current_user.authentication_token
       }
     }
   end
  end

  # DELETE /resource/sign_out
  def destroy
 
   respond_to do |format|

    #format.html { redirect_to after_sign_out_path_for(resource_name) }

     format.json {
       if current_user
         current_user.update authentication_token: nil
         signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
         render :json => {}.to_json, :status => :ok
       else
         render :json => {}.to_json, :status => :unprocessable_entity
       end
       

     }
   end
  end
end