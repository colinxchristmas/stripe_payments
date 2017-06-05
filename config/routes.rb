Rails.application.routes.draw do


  resources :addresses
  resources :subscriptions
  devise_for :users, path: 'users',
           controllers: { registrations: "registrations" },
           path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'},
           except: :create

  resources :users
  resources :products
  resources :sales
  resources :plans
  resources :cards

  root "homes#index"

  # basic routing for thank you page after sucessfull transaction
  get  '/purchases/thank-you',   to: 'transactions#thank_you',   as: :purchase_thanks

  # Generic routing for transactions on new products
  get  '/buy/:permalink',  to: 'transactions#new',          as: :show_buy
  post '/buy/:permalink',  to: 'transactions#create',       as: :buy

  mount StripeEvent::Engine => '/stripe-events'
end
