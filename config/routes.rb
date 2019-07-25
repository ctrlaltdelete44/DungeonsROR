# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get 'send_test_email', to: 'accounts#send_test_email'
  get 'test_migration', to: 'accounts#test_migration'
  
  resources :accounts do
    member do
      get :following, :followers, :favourites
    end
  end
  resources :account_activations,   only: [:edit]
  resources :password_resets,       only: %i[new create edit update]
  resources :microposts,            only: %i[create destroy]
  resources :relationships,         only: %i[create destroy]
  resources :favourites,            only: %i[create destroy]
  root to: 'static_pages#home'
end
