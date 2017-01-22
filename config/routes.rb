Rails.application.routes.draw do
  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'

  # Placeholder Route
  get 'guilds', to: 'application#show'
  get 'marketplace', to: 'application#show'
  get 'artists', to: 'application#show'
  get 'browse', to: 'application#show'

  resource :session, only: [:show, :create, :destroy], controller: 'session'
  resource :search, only: [:show], controller: 'search'

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

  resources :feedbacks, only: [:create]

  namespace :webhooks do
    post :patreon, to: 'patreon#create'
  end

  # if Rails.env.development?
  mount ResqueWeb::Engine => '/resque_web'
  # end

  get '/:user_id/:id', to: 'characters#show'
  get '*page', to: 'application#show'
end
