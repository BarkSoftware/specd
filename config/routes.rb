Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  get '/asplode', to: 'home#asplode'

  namespace :api do
    get '/', to: 'base#index'
    resources :projects do
      resources :issues, shallow: true
    end

    resources :columns do
      member do
        post :sort_kanban
      end
      resources :issues, shallow: true
    end

    get '/projects/:project_id/issues/:number', to: 'issues#show_by_number'

    resources :issues
    resources :uploads
    resources :collaborators
    resources :webhooks, only: [:create]
    get 'confirm-collaborator-token' => 'collaborators#show'

    post(
      'confirm-collaborator' => 'collaborators#confirm',
      as: :confirm_collaborator,
    )
  end

  get '/', to: 'application#index'
  get '/p/*all', to: 'application#index'
  get '/new-project', to: 'application#index'
end
