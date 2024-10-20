Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admin do
    resources :pay_outs, only: [:edit, :update]
    resources :distributions, only: :index
    resources :members, only: [] do
      collection do 
        get :active
        get :inactive
      end
      resources :contributions, only: [:new, :create] do
        collection { get :preview }
      end
    end
    resources :users, only: :destroy
  end

  get :membership, to: 'memberships#show'

  resources :contributions, only: :index
  resources :distributions, only: :index
  resources :pay_outs, only: :index
  resources :paypalme_handles, only: [:edit, :update]

  resources :dividends, only: [:index, :show] do
    member do 
      patch :pay_out
      patch :recontribute 
    end 
  end

  get :about, to: 'static_pages#about'
  get :check_email_spam, to: 'static_pages#check_email_spam'

  root 'static_pages#home'
end
