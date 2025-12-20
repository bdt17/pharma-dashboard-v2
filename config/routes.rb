Rails.application.routes.draw do
  root 'dashboard#index'  # Main dashboard
  
  get '/landing', to: 'home#landing'  # Marketing page
  
  resources :vehicles
  resources :geofences
  resources :alerts
  
  # API endpoints (if any)
  namespace :api do
    resources :vehicles, only: [:index, :update]
    resources :geofences, only: [:index, :create]
  end
  
  # Catch-all for dashboard
  get '/*path', to: 'dashboard#index'
end
