Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  resources :pods, only: %i[index show create destroy]

  root "home#show"
end
