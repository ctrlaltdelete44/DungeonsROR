Rails.application.routes.draw do
  get 'login/index'

  resources :accounts

  root 'login#index'
end
