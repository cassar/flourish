Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  resources :pots, only: %i[index show create destroy] do
    resources :distributions, only: :show
  end

  root "home#show"
end
