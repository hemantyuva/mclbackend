class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation, :mobile)
  end  

end