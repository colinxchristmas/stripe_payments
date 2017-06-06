Rails.application.routes.draw do


  resources :addresses
  resources :subscriptions
  devise_for :users, path: 'users',
           controllers: { registrations: "registrations" },
           path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'},
           except: :create

  scope :users do
    resources :cards
    # Generic routing for user purchases & subs
    get '/purchases', to: 'users#purchases',         as: :show_purchases
    get '/subscriptions', to: 'users#subscriptions', as: :show_subscriptions
  end

  # user resources is unused at the moment. Used better with roles defined and admin crud user.
  resources :users
  resources :products
  resources :sales
  resources :subscriptions, except: [:index]
  resources :plans, only: [:show]

  # no admin roles definded but showing all plans and subs would be a start
  scope :admin do
    resources :plans, except: [:show]
    resources :subscriptions, only: [:index]
  end


  root "homes#index"

  # basic routing for thank you page after sucessfull transaction
  get  '/purchases/thank-you',   to: 'transactions#thank_you',   as: :purchase_thanks
  get  '/subscriptions/thank-you',   to: 'subscriptions#thank_you',   as: :subscription_thanks

  # Generic routing for transactions on new products
  get  '/buy/:permalink',  to: 'transactions#new',          as: :show_buy
  post '/buy/:permalink',  to: 'transactions#create',       as: :buy



  mount StripeEvent::Engine => '/stripe-events'
end
