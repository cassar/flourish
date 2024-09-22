Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :dividends, only: [:show, :update]
    resources :members, only: [] do
      collection do 
        get :active
        get :inactive
      end
      resources :contributions, only: [:new, :create]
    end
  end

  get :membership, to: 'memberships#show'

  resources :contributions, only: :index
  resources :distributions, only: :index
  resources :pay_outs, only: :index
  resources :paypalmeids, only: [:edit, :update]

  resources :dividends, only: [:index, :show] do
    member { patch :pay_out, :recontribute } 
  end

  get :about, to: 'dashboard#about'

  root 'dashboard#dashboard'
end
