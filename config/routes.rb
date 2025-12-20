Rails.application.routes.draw do
  get "vehicles/update_gps"
  root 'admin#index'
  get '/admin', to: 'admin#index'
  
  namespace :api do
    post '/locations', to: 'locations#create'
  end
  
  mount ActionCable.server => '/cable'
end
get "/vehicles/update_gps", to: "vehicles#update_gps"
get "/vehicles", to: "vehicles#index"
