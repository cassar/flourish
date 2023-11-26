Rails.application.routes.draw do
  devise_for :users

  get :membership, to: 'memberships#show'
  get :payid, to: 'memberships#edit_payid'
  get :dividends, to: 'memberships#dividends'
  patch :membership, to: 'memberships#update'

  # Defines the root path route ("/")
  root 'dashboard#welcome'
end
