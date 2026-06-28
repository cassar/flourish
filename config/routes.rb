Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resource :membership, only: :show

  namespace :admin do
    resources :members, only: %i[index show]
  end

  root 'static_pages#home'
end
