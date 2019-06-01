Rails.application.routes.draw do
  get 'login/index'

  resources :campaigns

  root 'login#index'
end
