Rails.application.routes.draw do
  devise_for :users, path: 'users',
           controllers: { registrations: "registrations" },
           path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'},
           except: :create
  resources :users
  mount StripeEvent::Engine => '/stripe-events'
end
