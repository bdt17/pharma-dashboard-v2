Rails.application.routes.draw do
  root 'admin#index'
  get '/admin', to: 'admin#index'
  
  namespace :api do
    post '/locations', to: 'locations#create'
  end
  
  mount ActionCable.server => '/cable'
end
