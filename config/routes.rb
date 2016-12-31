Rails.application.routes.draw do
  root 'application#show', page: :home

  get '/c/:id', to: 'shortcodes#show'
  get '/u/*path', to: redirect('/users/%{path}')

  resources :users, only: [:show] do
    resources :characters, only: [:index, :show, :update] do
      resources :swatches, only: [:index, :create, :update, :destroy]
      resources :images, only: [:index, :create, :update, :destroy]
    end

    get '/*path', to: redirect('/users/%{user_id}/characters/%{path}')
  end

  get '*page', to: 'application#show'
end
