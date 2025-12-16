Rails.application.routes.draw do
  get "up" => "rails/health#show"
  resources :products
  root "products#index"
end
