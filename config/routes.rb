Rails.application.routes.draw do
  devise_for :users
  root "dashboard#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :locations
  resources :fields do
    resources :field_observations, only: [:create, :destroy]
  end
  resources :growth_stages
  resources :planting_events
  get "weather-data", to: "weather_data#index", as: :weather_data
  get "degree-days", to: "degree_days#index", as: :degree_days
  get "map", to: "map#index", as: :map
end
