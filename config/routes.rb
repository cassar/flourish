Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :contributions, only: %i[edit update]
  resources :activations, only: %i[edit update]
  resources :inactivations, only: %i[edit update]

  # Defines the root path route ("/")
  root 'dashboard#welcome'
end
