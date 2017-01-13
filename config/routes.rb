Rails.application.routes.draw do
  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'

  # Placeholder Route
  get 'marketplace', to: 'application#show'
  get 'guilds', to: 'application#show'
  get 'artists', to: 'application#show'

  resource :session, only: [:show, :create, :destroy], controller: 'session'

  resources :users, only: [:index, :show, :create, :update] do
    resources :characters, only: [:show, :update, :create, :destroy] do
      resources :swatches, only: [:index, :create, :update, :destroy], shallow: true
      resources :images, only: [:index, :show, :create, :update, :destroy], shallow: true
    end
  end

  get '*page', to: 'application#show'
end
