Rails.application.routes.draw do
  get "login", to: "sessions#new", as: "new_sessions"
  post "login", to: "sessions#create", as: "create_sessions"
  delete "logout", to: "sessions#destroy", as: "destroy_sessions"
  resources :pokemons
  resources :users, only: [:new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
