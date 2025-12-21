Rails.application.routes.draw do
  root "dashboard#index"
  get '/dashboard', to: 'dashboard#index'
  resources :vehicles, only: [:index] do
    member do
      get :map
    end
  end
  get '/map', to: 'vehicles#map'
  get '/audit_events', to: 'audit_events#index'
  get '/geofences', to: 'geofences#index'
  get '/sensor_readings', to: 'sensor_readings#index'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
end
