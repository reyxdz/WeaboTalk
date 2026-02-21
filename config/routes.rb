Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    sessions: "users/sessions",
    passwords: "users/passwords"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Forms validation
  post "forms/validate", to: "forms#validate", as: :validate_form

  # Pages
  get "home", to: "pages#home"

  # User Profiles
  get "/profiles/:username", to: "profiles#show", as: :profile
  get "/profiles/:username/edit", to: "profiles#edit", as: :edit_profile
  patch "/profiles/:username", to: "profiles#update"
  put "/profiles/:username", to: "profiles#update"

  # Users
  get "users/search", to: "users#search", as: :search_users
  get "users/:id", to: "users#show", as: :user

  # Posts with nested comments, likes, and reactions
  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
    resources :reactions, only: [ :create, :destroy ]
    member do
      patch :publish
    end
  end
  post "posts/save-draft", to: "posts#save_draft", as: :save_draft_post
  get "my-drafts", to: "posts#drafts", as: :drafts_posts

  # Friendships
  resources :friendships, only: [ :create, :destroy, :update, :index ]
  get "friend-requests", to: "friendships#pending_requests", as: :pending_friend_requests

  # Notifications
  resources :notifications, only: [ :index, :destroy ]
  patch "notifications/:id/mark-as-read", to: "notifications#mark_as_read", as: :mark_notification_as_read
  patch "notifications/mark-all-as-read", to: "notifications#mark_all_as_read", as: :mark_all_notifications_as_read

  # Defines the root path route ("/")
  root "pages#home"
end
