class SubscriptionsController < ApplicationController
  def new
    @plans = {
      smb: { id: 'price_99_smb', name: 'SMB ($99/mo)', amount: 99 },
      enterprise: { id: 'price_2k_ent', name: 'Enterprise ($2K/mo)', amount: 2000 }
    }
  end

  def create
    customer = Stripe::Customer.create(email: current_user&.email || params[:email])
    
    subscription = Stripe::Subscription.create(
      customer: customer.id,
      items: [{ price: params[:plan_id] }],
      payment_behavior: 'default_incomplete',
      expand: ['latest_invoice.payment_intent']
    )
    
    # Update organization subscription
    org = current_user&.organization || Organization.create(name: params[:org_name])
    org.update!(
      stripe_customer_id: customer.id,
      subscription_attributes: {
        stripe_subscription_id: subscription.id,
        status: 'active',
        plan: params[:plan_id]
      }
    )
    
    redirect_to subscription.latest_invoice.payment_intent.next_action.redirect_to_url, 
                allow_other_host: true
  end
end
