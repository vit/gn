Rails.application.routes.draw do

  get 'home/index'
#  get 'help', to: "home#help"

  root 'home#index'


  devise_for :users, controllers: {registrations: 'custom_registrations'}

  get 'welcome/index'

#  root 'welcome#index'

#  resources :journals, only: [:show]

#  get 'office/index'
  get '/office/', to: 'office#show'

  resources :submissions #, only: [:show]
#  resources :submission_revision_files
  resources :submission_files

  resources :e_submissions, only: [:index, :show, :update]
  resources :r_submissions, only: [:index, :show, :update]


end
