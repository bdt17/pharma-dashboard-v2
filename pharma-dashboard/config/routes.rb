Rails.application.routes.draw do
  root "dashboard#index"
  
  # ADD THIS LINE:
  get "vehicles.json", to: "dashboard#vehicles_json"
  
  resources :products
  namespace :api do
    namespace :v1 do
      resources :locations, only: :create
    end
  end
end
