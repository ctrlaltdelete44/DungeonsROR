Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'accounts#new'
  post '/signup', to: 'accounts#create'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  resources :accounts

  root 'static_pages#home'
end