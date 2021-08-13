Rails.application.routes.draw do
  resources :reviews
  resources :listings
  resources :profiles
  devise_for :users
  get 'listings', to: 'listings#index'
  get 'listings/:id', to: 'listings#show'
  root 'home#page'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
