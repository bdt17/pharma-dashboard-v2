Rails.application.routes.draw do
  devise_for :drivers

  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"

  namespace :drivers do
    get :dashboard, to: "dashboard#index"
  end
end
