get 'dashboard', to: 'dashboard#index'
Rails.application.routes.draw do
  # Health checks first
  get '/health/live', to: 'health#live'
  get '/health/ready', to: 'health#ready'
  get '/health/detailed', to: 'health#detailed'

  # Stripe webhooks & billing
  namespace :stripe do
    post 'webhooks', to: 'webhooks#create'
    post 'checkout_sessions', to: 'checkout_sessions#create'
    get 'checkout_sessions/success', to: 'checkout_sessions#success'
    get 'checkout_sessions/cancel', to: 'checkout_sessions#cancel'
    post 'checkout_sessions/portal', to: 'checkout_sessions#portal'
  end
  get 'billing', to: 'billing#index'
  get 'billing/plans', to: 'billing#plans'
  post 'billing/subscribe', to: 'billing#subscribe'

  # API routes (before SPA catch-all)
  post '/api/forecast/:vehicle_id', to: 'sensors#forecast'
  post '/api/tamper/:vehicle_id', to: 'sensors#tamper'
  get '/api/vision', to: 'sensors#vision'
  get '/api/gps/:id', to: 'sensors#gps'
  get '/api/subscribe', to: 'sensors#subscribe'
  get '/api/jetson', to: 'sensors#jetson'
  get '/api/compliance/audit', to: 'compliance#audit'
  post '/api/compliance/sign', to: 'compliance#sign'
  get '/api/compliance/versions/:item_type/:item_id', to: 'compliance#versions'

  namespace :api do
    namespace :v1 do
      get 'dashboard', to: 'dashboard#index'
      get 'tenant', to: 'tenants#show'
      patch 'tenant', to: 'tenants#update'
      get 'tenant/stats', to: 'tenants#stats'
      resources :api_keys, only: [:index, :show, :create, :update, :destroy] do
        post :rotate, on: :member
      end
      resources :shipments do
        get :temperature_events, on: :member
        get :geofence_events, on: :member
        get :alerts, on: :member
      end
      # ... rest of your api/v1 resources (unchanged)
      get 'status', to: 'status#index'
      get 'status/health', to: 'status#health'
      get 'status/metrics', to: 'status#metrics'
      get 'status/ready', to: 'status#ready'
      get 'status/live', to: 'status#live'
    end
  end

  # Admin dashboard (FDA compliance)
  namespace :admin do
    get 'compliance', to: 'compliance#index', as: :compliance
    get 'compliance/export', to: 'compliance#export', as: :compliance_export
    get 'compliance/verify', to: 'compliance#verify', as: :compliance_verify
    get 'compliance/report', to: 'compliance#report', as: :compliance_report
    get 'compliance/search', to: 'compliance#search', as: :compliance_search
    get 'analytics', to: 'analytics#index', as: :analytics
    get 'analytics/mrr', to: 'analytics#mrr', as: :mrr_analytics
    get 'analytics/churn', to: 'analytics#churn', as: :churn_analytics
    get 'analytics/tenants', to: 'analytics#tenants', as: :tenants_analytics
    get 'analytics/export', to: 'analytics#export', as: :export_analytics
    post 'analytics/sync', to: 'analytics#sync', as: :sync_analytics
  end

  # Main React SPA routes (CATCH-ALL LAST)
  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/shipments', to: 'dashboard#shipments'
  get 'dashboard/audit_trail', to: 'dashboard#audit_trail'
  get 'dashboard/subscription_required', to: 'dashboard#subscription_required'
  get 'pfizer', to: 'partners#pfizer'
  resources :sensors
  resources :partners
  get '/trackings', to: 'trackings#index'
  get '/sensors/:id/live', to: 'sensors#live'
  get '/pharma/status', to: 'pharma#status'
  get '/audits/:shipment_id', to: 'audits#shipment_log'

  # ActionCable
  mount ActionCable.server => '/cable'
end
