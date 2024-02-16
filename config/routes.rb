Rails.application.routes.draw do
  devise_for :users

  get :membership, to: 'memberships#show'
  get :payid, to: 'memberships#edit_payid'
  patch :membership, to: 'memberships#update'

  resources :dividends, only: [:index, :show] do
    member { patch :pay_out, :recontribute } 
  end

  namespace :admin do
    resources :dividends, only: [:show, :update]
    post :up_bank, to: 'admin/up_bank#webhooks'
  end

  get :distributions, to: 'dashboard#distributions'

  # Defines the root path route ("/")
  root 'dashboard#dashboard'
end
