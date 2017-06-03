Rails.application.routes.draw do

  resources :subscriptions
  devise_for :users, path: 'users',
           controllers: { registrations: "registrations" },
           path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'},
           except: :create

  resources :users
  resources :products
  resources :sales
  resources :plans

  root "homes#index"
  
  mount StripeEvent::Engine => '/stripe-events'
end
