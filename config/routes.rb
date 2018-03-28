Rails.application.routes.draw do

  get 'home/index'
#  get 'help', to: "home#help"
  root 'home#index'

#  devise_for :users, controllers: {registrations: 'custom_registrations'}

  devise_for :users, skip: :registrations, controllers: {registrations: 'custom_registrations'}
  devise_scope :user do
#    resource :custom_registration,
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
#      controller: 'devise/registrations',
      controller: 'custom_registrations',
      as: :user_registration do
        get :cancel
      end
  end

#  devise_scope :user do
#    get 'session/on_signin', :to => 'sessions#memorize_session'
#  end

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
      get 'timeline'
      get 'show_print'
    end
    collection do
      get 'people'
      post 'people_update'
      post 'people_find'
    end
  end
  resources :r_submissions, only: [:index, :show, :update] do
    member do
      get 'revisions'
      put 'update_review'
    end
  end

end
