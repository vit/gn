Rails.application.routes.draw do

  get 'home/index'
#  get 'help', to: "home#help"
  root 'home#index'

  devise_for :users, controllers: {registrations: 'custom_registrations'}

#  get 'welcome/index'
#  root 'welcome#index'
#  resources :journals, only: [:show]

#  get 'office/index'
  get '/office/', to: 'office#show'

  resources :submissions, except: [:edit] do
    member do
      get 'edit_text'
      get 'wizard_files'
      get 'wizard_authors'
      get 'edit_authors'
      put 'update_authors'
      get 'revisions'
    end
  end

#  resources :submission_revision_files
  resources :submission_files
  resources :submission_revision_reviews, only: [] do
    member do
      put 'editor_update'
#      delete 'editor_update'
#      delete 'editor_drop'
    end
  end

  resources :e_submissions, only: [:index, :show, :update] do
    member do
      get 'revisions'
    end
  end
  resources :r_submissions, only: [:index, :show, :update] do
    member do
      get 'revisions'
    end
  end

end
