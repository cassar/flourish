Rails.application.routes.draw do
  devise_for :users

  get :membership, to: 'memberships#show'

  resources :contributions, only: :index

  resources :dividends, only: [:index, :show] do
    member { patch :pay_out, :recontribute } 
  end

  resources :pay_outs, only: [:index]
  resources :payids, only: [:edit, :update]

  namespace :admin do
    resources :dividends, only: [:show, :update]
    post :up_bank, to: 'admin/up_bank#webhooks'
  end

  get :distributions, to: 'dashboard#distributions'

  root 'dashboard#dashboard'
end
