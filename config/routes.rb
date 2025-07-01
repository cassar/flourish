Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  namespace :admin do
    resources :distributions, only: :index
    resources :users, only: :destroy
    resources :dividends, only: [] do
      resources :pay_outs, only: [:new, :create] do
        collection { get :preview }
      end
    end
    resources :members, only: [] do
      resources :contributions, only: [:new, :create] do
        collection { get :preview }
      end
      collection do 
        get :active
        get :inactive
      end
    end
  end

  resources :contributions, only: :index
  resources :distributions, only: [:index, :show]
  resources :pay_outs, only: :index
  resources :paypalme_handles, only: [:edit, :update]
  resources :currencies, only: [:edit, :update]
  resources :dividends, only: [:index, :show] do
    member do 
      patch :pay_out
      patch :recontribute 
    end 
  end

  get :membership, to: 'memberships#show'
  get :about, to: 'static_pages#about'
  get :mission, to: 'static_pages#mission'
  get :check_email_spam, to: 'static_pages#check_email_spam'
  get :privacy_statement, to: 'static_pages#privacy_statement'
  get :post_fear, to: 'static_pages#post_fear'
  get :notification_preferences, to: 'notification_preferences#edit'
  patch :notification_preferences, to: 'notification_preferences#update'

  root 'static_pages#home'
end
