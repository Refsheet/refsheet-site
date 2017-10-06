Rails.application.routes.draw do
  constraints ShortcodeDomainConstraint do
    root to: redirect('https://refsheet.net')
    get '/c/:id', to: 'shortcodes#show'
    get '/f/:id', to: 'forums#shortcode'
    get '/i/:id', to: 'images#shortcode'
    get '/t/:id', to: 'forum/threads#shortcode'
    get '/u/:id', to: 'users#shortcode'
    get '*id', to: 'shortcodes#show'
  end

  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'

  # Placeholder Route
  get 'register', to: 'application#show'
  get 'guilds', to: 'application#show'
  get 'marketplace', to: 'application#show'
  get 'artists', to: 'application#show'
  get 'browse', to: 'application#show'
  get 'browse/users', to: 'application#show'


  #== Account Stuff

  namespace :account do
    get '/activity' => 'activities#index'
  end


  resource :session, only: [:show, :create, :destroy, :update], controller: 'session'
  resource :password_resets, only: [:create, :update]
  get 'login', to: 'session#new'

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

  #== Browsing

  resource :explore, only: [:show] do
    member do
      get :favorites
      get :popular
    end
  end


  #== Forums

  resources :forums, only: [:index, :show] do
    resources :threads, only: [:index, :show, :create], controller: 'forum/threads' do
      resources :posts, only: [:index, :show, :create], controller: 'forum/posts'
    end

    get ':id', to: 'forum/threads#show'
  end


  #== Webhooks

  namespace :webhooks do
    post :patreon, to: 'patreon#create'
  end

  namespace :admin do
    root to: 'dashboard#show'

    resources :users, except: [:destroy]
    resources :characters, except: [:destroy]
    resources :images, except: [:destroy]
    resources :pledges, only: [:index, :show]
    resources :changelogs, only: [:index, :show]
    resources :forums, only: [:index, :show, :update, :create]

    resources :feedbacks, only: [:index, :show, :update] do
      resources :replies, only: [:create], controller: 'feedbacks/replies'
    end
  end

  if Rails.env.development?
    mount ResqueWeb::Engine => '/resque_web'
    mount LetterOpenerWeb::Engine => '/letter_opener'
  end

  #== Static Routes

  %w(privacy terms support).each do |path|
    get "/#{path}", to: 'static#show'
  end

  get '/static/:id', to: 'static#show', as: :static

  get '/:user_id/:id', to: 'characters#show', as: :character_profile
  get '/:id', to: 'users#show', as: :user_profile
  get '*page', to: 'application#show'
end
