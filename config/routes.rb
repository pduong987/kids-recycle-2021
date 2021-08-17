Rails.application.routes.draw do
  
  # Custom override routes. Need to be above listing resource
  get 'listings/swap', to: 'listings#swap'
  post 'listings/swap', to: 'listings#doswap'

  resources :reviews
  resources :listings
  resources :profiles
  devise_for :users
  root 'home#page'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
