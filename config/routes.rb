Rails.application.routes.draw do
  devise_for :users

  get :membership, to: 'memberships#show'
  # Defines the root path route ("/")
  root 'dashboard#welcome'
end
