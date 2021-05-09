class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    paid = perform_payment
  end

  private

  def perform_payment    
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params['stripeToken'],
      description: 'World Wide Netflix Subscription'
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: 100*100,
      currency: 'sek'
    )
  end
end
