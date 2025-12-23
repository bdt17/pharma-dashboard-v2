class SubscriptionsController < ApplicationController
  def new
    @plans = {
      smb: { id: 'price_99_smb', name: 'SMB ($99/mo)', amount: 99 },
      enterprise: { id: 'price_2k_ent', name: 'Enterprise ($2K/mo)', amount: 2000 }
    }
  end

  def create
    # FAKE subscription for demo
    org = current_user&.organization || Organization.create(name: params[:org_name] || 'Demo Org')
    org.create_subscription!(
      stripe_subscription_id: 'demo_' + SecureRandom.hex(8),
      status: 'active',
      plan: params[:plan_id]
    )
    
    redirect_to dashboard_path, notice: "✅ Enterprise Active! $#{params[:plan_id].split('_')[1].to_i}/mo"
  end
end
