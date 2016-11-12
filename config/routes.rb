Rails.application.routes.draw do

  get 'home/index'
  root 'home#index'


  devise_for :users
  get 'welcome/index'

#  root 'welcome#index'
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
