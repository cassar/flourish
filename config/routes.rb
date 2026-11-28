Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  resources :pots, only: %i[index show create] do
    resources :distributions, only: :show
    resources :members, only: :show
    resources :contributions, only: %i[new create]
    resource :membership, only: :destroy, controller: 'pot_memberships'
  end

  root "home#show"
end
