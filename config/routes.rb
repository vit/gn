Rails.application.routes.draw do

  get 'home/index'
  root 'home#index'


  devise_for :users
  get 'welcome/index'

#  root 'welcome#index'

#  resources :journals, only: [:show]

#  get 'office/index'
  get '/office/', to: 'office#show'

  resources :submissions #, only: [:show]


end
