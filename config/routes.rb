Rails.application.routes.draw do
  # ═══════════════════════════════════════════════════════════════════════════
  # HEALTH CHECKS - Kubernetes probes (no auth, before everything)
  # ═══════════════════════════════════════════════════════════════════════════
  get '/health/live', to: 'health#live'
  get '/health/ready', to: 'health#ready'
  get '/health/detailed', to: 'health#detailed'

  # API ROUTES FIRST - Before React SPA catch-all
  post '/api/forecast/:vehicle_id', to: 'sensors#forecast'
  post '/api/tamper/:vehicle_id', to: 'sensors#tamper'
  get '/api/vision', to: 'sensors#vision'

  # Phase 11.5 Partner API - RESTful /api/v1 endpoints
  namespace :api do
    namespace :v1 do
      # Tenant (current tenant based on API key)
      get 'tenant', to: 'tenants#show'
      patch 'tenant', to: 'tenants#update'
      get 'tenant/stats', to: 'tenants#stats'

      # API Keys management
      resources :api_keys, only: [:index, :show, :create, :update, :destroy] do
        post :rotate, on: :member
      end

      # Core resources
      resources :shipments do
        get :temperature_events, on: :member
        get :geofence_events, on: :member
        get :alerts, on: :member
      end

      resources :temperature_events, only: [:index, :show, :create] do
        post :bulk, on: :collection, action: :bulk_create
      end

      resources :geofence_events, only: [:index, :show, :create]

      resources :alerts, only: [:index, :show, :create] do
        post :acknowledge, on: :member
        post :resolve, on: :member
        get :summary, on: :collection
      end

      # Audit logs (read-only with verification)
      resources :audit_logs, only: [:index, :show] do
        get :verify, on: :collection
        get :for_resource, on: :collection
      end
    end
  end

  # React SPA routes AFTER APIs
  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/shipments', to: 'dashboard#shipments'
  get 'dashboard/audit_trail', to: 'dashboard#audit_trail'
  get 'pfizer', to: 'partners#pfizer'
  resources :sensors
  resources :partners

  get '/api/gps/:id', to: 'sensors#gps'           # Phase 14 GPS
  get '/api/subscribe', to: 'sensors#subscribe'  # Phase 14 Stripe
  get '/api/jetson', to: 'sensors#jetson'        # Phase 14 Vision

  get '/api/compliance/audit', to: 'compliance#audit'
  post '/api/compliance/sign', to: 'compliance#sign'
end
