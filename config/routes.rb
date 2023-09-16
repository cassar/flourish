Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :contributions, except: [:index, :show, :delete]

  # Defines the root path route ("/")
  root "static_pages#welcome"
end
