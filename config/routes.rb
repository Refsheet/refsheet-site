Rails.application.routes.draw do
  constraints ShortcodeDomainConstraint do
    root to: redirect('https://refsheet.net'), as: :shortcode_root
    get '/c/:id', to: 'shortcodes#show'
    get '/e/*url', to: 'image_proxy#get', as: :image_proxy
    get '/f/:id', to: 'forums#shortcode'
    get '/i/:id', to: 'images#shortcode'
    get '/l/:id', to: 'advertisement_slots#shortcode'
    get '/t/:id', to: 'forum/threads#shortcode' # TODO: rename controller to DiscussionsController
    get '/u/:id', to: 'users#shortcode'
    get '*id', to: 'shortcodes#show'
  end

  get '/sitemap.xml', to: redirect('http://refsheet-prod.s3.amazonaws.com/sitemaps/sitemap.xml.gz')

  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'

  # Email Things
  get 'unsubscribe', to: 'emails#unsubscribe'

  # Placeholder Route
  get 'register', to: 'application#show'
  get 'guilds', to: 'application#show'
  get 'artists', to: 'application#show'
  get 'browse', to: 'application#show'
  get 'browse/users', to: 'application#show'
  get 'moderate', to: 'application#show'


  #== Advertising

  get '/our_friends/next', to: 'advertisement_slots#next'


  #== Account Stuff

  namespace :account do
    if false
      get '/activity' => 'activities#index'
    end
    
    resource :settings, only: [:show, :update]

    resource :notifications, only: [:show, :update] do
      member do
        put :browser_push
      end
    end

    resource :support, only: [:show] do
      resource :patron, only: [:update] do
        member do
          get :link
        end
      end
    end
  end

  resources :notifications, only: [:index, :update], controller: 'account/notifications' do
    collection do
      put :bulk_update
    end
  end


  #== Login

  resource :session, only: [:show, :create, :destroy, :update], controller: 'session'
  resource :password_resets, only: [:create, :update]
  get 'login', to: 'session#new'
  # todo: change these to POST and add second step in UI
  get 'activate/:auth', to: 'session#activate', as: :activate
  get 'confirm_email_change/:auth', to: 'session#confirm_email_change', as: :confirm_email_change
  get 'recover/:auth', to: 'session#recover', as: :recover


  #== Front-End Legacy

  resources :characters, only: [:index]

  resources :character_groups, only: [:create, :update, :destroy] do
    resources :characters, only: [:create, :destroy], controller: 'character_groups/characters'
  end

  resources :transfers, only: [:update]

  resources :users, only: [:index, :show, :create, :update] do
    collection do
      get :suggested, to: 'follows#suggested'
    end

    resource :follow, only: [:show, :create, :destroy]

    resources :characters, only: [:show, :update, :create, :destroy] do
      resources :attributes, only: [:create, :update, :destroy], controller: 'characters/attributes'
      resources :swatches, only: [:index, :create, :update, :destroy], shallow: true
      resources :images, only: [:index, :show, :create, :update, :destroy], shallow: true do
        member do
          get :full
          get :refresh
        end
      end
    end
  end

  resources :media, only: [:show], controller: 'images' do
    delete :favorites, to: 'media/favorites#destroy'

    resources :favorites, only: [:index, :create], controller: 'media/favorites'
    resource :favorite, only: [:destroy], controller: 'media/favorites'
    resources :comments, only: [:index, :create, :destroy], controller: 'media/comments'
  end

  resources :reports, only: [:create]

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

  # The Forums have not been used much for lack of moderation and proper categories, etc. I just looked, 
  # and it's an incredible cesspool of spam. I'm shutting those down now as part of the temporary cuts 
  # to get costs under control, and later we'll re-implement them.
  # src: https://twitter.com/refsheet/status/1710715921138954471
  if false
    resources :forums, only: [:index, :show] do
      get ':id', to: 'forum/threads#show', as: :thread # TODO: Rename to discussions
  
      resources :threads, only: [:index, :show, :create], controller: 'forum/threads' do
        resources :posts, only: [:index, :show, :create], controller: 'forum/posts'
      end
    end
  end


  #== Asks / Blog

  get 'ask/:shortcode', to: 'asks#index'
  get 'ask/:shortcode/:id', to: 'asks#show'

  #== Marketplace

  if false
    namespace :marketplace do
      root to: 'test#show'
  
      get :sell, to: 'test#sell'
      get :cart, to: 'test#cart'
      get :orders, to: 'test#orders'
      get :sales, to: 'test#sales'
      get :setup, to: 'test#setup'
  
      post :test_listing, to: 'test#create_listing'
      post :test_cart, to: 'test#create_cart'
      post :test_payment, to: 'test#create_payment'
      post :test_setup, to: 'test#create_seller'
      post :setup, to: 'test#create_bank_account'
  
      delete :test_listing, to: 'test#destroy_listing'
      delete :test_cart, to: 'test#destroy_cart'
    end
  end

  resources :artists, only: [:index, :show]

  #== Webhooks

  namespace :webhooks do
    post :patreon, to: 'patreon#create'
  end


  #== Admin

  namespace :admin do
    root to: 'dashboard#show'

    resources :users, except: [:destroy]
    resources :characters, except: [:destroy]
    resources :images, except: [:destroy] do
      get :download
    end
    resources :pledges, only: [:index, :show]
    resources :changelogs, only: [:index, :show]
    resources :forums, only: [:index, :show, :update, :create]

    resources :feedbacks, only: [:index, :show, :update] do
      resources :replies, only: [:create], controller: 'feedbacks/replies'
    end

    resources :artists, only: [:index, :show, :edit, :new, :create, :update]

    resources :moderation_reports, only: [:index, :show, :update]

    resources :ads, only: [:index, :edit, :new, :create, :update]
    post :ad_slots, to: 'advertisements/slots#create'
  end

  #== Back End

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"


  #== Engines!

  if Rails.env.development?
    mount LetterOpenerWeb::Engine => '/letter_opener'

    get :bad_request, to: 'application#bad_request!'
    get :not_found, to: 'application#not_found!'
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount Ahoy::Engine => '/ahoy', as: :my_ahoy

  #== API

  namespace :api do
    root to: 'api#documentation'

    namespace :v1 do
      resources :users, only: [:show, :update] do
        collection do
          get '/lookup/:username', to: 'users#lookup'
        end
      end
    end

    match '*path', to: 'api#not_found!', via: [:get, :post, :put, :patch, :delete, :head, :options]
  end

  #== Static Routes

  %w(privacy terms support thanks).each do |path|
    get "/#{path}", to: 'static#show'
  end

  get '/static/:id', to: 'static#show', as: :static

  get '/:user_id/:id', to: 'characters#show', as: :character_profile

  get '/~:id', to: 'users#show'
  get '/:id', to: 'users#show', as: :user_profile

  get '*page', to: 'application#show'

  match '*not_found', to: 'application#not_found!', via: [:post, :put, :patch, :delete, :head, :options]
  post '/', to: 'application#not_found!'
end
