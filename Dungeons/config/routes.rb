Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'accounts#new'
  post '/signup', to: 'accounts#create'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  resources :accounts do
    member do
      get :following, :followers, :favourites
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,	    only: [:new, :create, :edit, :update]
  resources :microposts,		      only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :favourites,          only: [:create, :destroy]
  root 'static_pages#home'
end
