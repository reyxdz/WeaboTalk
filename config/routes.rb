Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Pages
  get "home", to: "pages#home"

  # User Profiles
  get "/profiles/:username", to: "profiles#show", as: :profile
  get "/profiles/:username/edit", to: "profiles#edit", as: :edit_profile
  patch "/profiles/:username", to: "profiles#update"
  put "/profiles/:username", to: "profiles#update"

  # Defines the root path route ("/")
  root "pages#home"
end
