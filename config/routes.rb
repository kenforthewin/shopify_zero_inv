Rails.application.routes.draw do
  root 'products#index'
  get '/orders.json', to: 'orders#index'
  post '/products/destroy_zero', to: 'products#destroy_zero'
  get '/products/sync', to: 'products#sync'
  get '/shops/activate', to: 'shops#activate', as: :activate
  get 'shops/activate-and-redirect', to: 'shops#activate_and_redirect', as: :activate_and_redirect
  get 'shops/charge_declined', to: 'shops#charge_declined', as: :charge_declined
  get '/shops/callback', to: 'shops#callback', as: :shops_callback
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
