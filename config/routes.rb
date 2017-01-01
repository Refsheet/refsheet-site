Rails.application.routes.draw do
  root 'application#show', page: :home
  get '/health', to: 'public#health'

  get '/c/:id', to: 'shortcodes#show'
  get '/u/*path', to: redirect('/users/%{path}')

  resource :session, only: [:show, :create, :destroy], controller: 'session'

  resources :users, only: [:show, :create, :update] do
    resources :characters, only: [:index, :show, :update] do
      resources :swatches, only: [:index, :create, :update, :destroy]
      resources :images, only: [:index, :create, :update, :destroy]
    end

    get '/*path', to: redirect('/users/%{user_id}/characters/%{path}')
  end

  get '*page', to: 'application#show'
end
