Rails.application.routes.draw do
  root "admin#index"
  resources :vehicles
end
  get '/update_gps', to: 'vehicles#update_gps'
