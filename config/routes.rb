Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admin do
    resources :dividends, only: [:show, :update]
    resources :distributions, only: :index
    resources :members, only: [] do
      collection do 
        get :active
        get :inactive
      end
      resources :contributions, only: [:new, :create]
    end
    resources :users, only: :destroy
  end

  get :membership, to: 'memberships#show'

  resources :contributions, only: :index
  resources :distributions, only: :index
  resources :pay_outs, only: :index
  resources :paypalmeids, only: [:edit, :update]

  resources :dividends, only: [:index, :show] do
    member { patch :pay_out, :recontribute } 
  end

  get :about, to: 'static_pages#about'
  get :check_email_spam, to: 'static_pages#check_email_spam'

  root 'static_pages#home'
end
