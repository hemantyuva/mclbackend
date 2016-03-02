class SubscribersController < ApplicationController

def create
  # Amount in cents
  @amount = 100

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

  current_user.subscribed = true
			current_user.stripeid = customer.id
			current_user.save

			redirect_to settings_path

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end


	def update

			token = params[:stripeToken]
			customer = Stripe::Customer.create(
			card: token,
			plan: Free,
			emai: current_user.email
			)

			current_user.subscribed = true
			current_user.stripeid = customer.id
			current_user.save

			redirect_to settings_path
	end	

end
