Rails.application.routes.draw do
  constraints ShortcodeDomainConstraint do
    root to: redirect('https://refsheet.net')
    get '*id', to: 'shortcodes#show'
  end

  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'

  # Placeholder Route
  get 'login', to: 'application#show'
  get 'register', to: 'application#show'
  get 'guilds', to: 'application#show'
  get 'marketplace', to: 'application#show'
  get 'artists', to: 'application#show'
  get 'browse', to: 'application#show'
  get 'browse/users', to: 'application#show'

  resource :session, only: [:show, :create, :destroy, :update], controller: 'session'

  resources :characters, only: [:index]

  resources :character_groups, only: [:create, :update, :destroy] do
    resources :characters, only: [:create, :destroy], controller: 'character_groups/characters'
  end

  resources :transfers, only: [:update]

  resources :users, only: [:index, :show, :create, :update] do
    resources :characters, only: [:show, :update, :create, :destroy] do
      resources :swatches, only: [:index, :create, :update, :destroy], shallow: true
      resources :images, only: [:index, :show, :create, :update, :destroy], shallow: true do
        member do
          get :full
        end
      end
    end
  end

  resources :media, only: [:show] do
    resources :favorites, only: [:index, :create], controller: 'media/favorites'
    resource :favorite, only: [:destroy], controller: 'media/favorites'
    resources :comments, only: [:index, :create, :destroy], controller: 'media/comments'
  end

  resources :feedbacks, only: [:create]
  resources :pledges, only: [:index]

  namespace :webhooks do
    post :patreon, to: 'patreon#create'
  end

  namespace :admin do
    root to: 'dashboard#show'

    resources :users, except: [:destroy]
    resources :characters, except: [:destroy]
    resources :images, except: [:destroy]
    resources :pledges, only: [:index, :show]
    resources :feedbacks, only: [:index, :show]
    resources :changelogs, only: [:index, :show]
  end

  if Rails.env.development?
    mount ResqueWeb::Engine => '/resque_web'
    mount LetterOpenerWeb::Engine => '/letter_opener'
  end

  get '/:user_id/:id', to: 'characters#show', as: :character_profile
  get '/:id', to: 'users#show', as: :user_profile
  get '*page', to: 'application#show'
end
