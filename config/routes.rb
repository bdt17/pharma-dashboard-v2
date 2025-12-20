Rails.application.routes.draw do
  root "admin#index"
  resources :vehicles
  get '/update_gps', to: 'vehicles#update_gps'
end
