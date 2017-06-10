Rails.application.routes.draw do
  root "sessions#new"

  resources :sessions, only: [:new, :create, :destroy]
  resources :products
  resources :clients do
    resources :orders, only: [:new, :create, :update, :destroy]
  end
  resources :orders, only: [:show, :index]

  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :activities, only: [:index]
  end
end
