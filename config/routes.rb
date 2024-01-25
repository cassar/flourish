Rails.application.routes.draw do
  devise_for :users

  get :membership, to: 'memberships#show'
  get :payid, to: 'memberships#edit_payid'
  get :dividends, to: 'memberships#dividends'
  patch :membership, to: 'memberships#update'

  resources :dividends, only: [] do
    member { patch :pay_out }
  end

  namespace :admin do
    resources :dividends, only: [:show, :update]
    post :up_bank, to: 'admin/up_bank#webhooks'
  end

  # Defines the root path route ("/")
  root 'dashboard#dashboard'
end
