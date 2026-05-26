Rails.application.routes.draw do
  devise_for :users
  get '/login', to: redirect('/users/sign_in')
  root "dashboard#index"
  get "dashboard/export", to: "dashboard#export", as: :dashboard_export
  get "up" => "rails/health#show", as: :rails_health_check

  resources :locations
  get "fields.geojson", to: "fields#geojson_collection"
  resources :fields do
    resources :field_observations, only: [:create, :update, :destroy]
  end
  resources :growth_stages
  resources :planting_events
  get "weather-data", to: "weather_data#index", as: :weather_data
  get "degree-days", to: "degree_days#index", as: :degree_days
  get "map", to: "map#index", as: :map
end
