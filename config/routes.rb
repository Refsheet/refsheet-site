Rails.application.routes.draw do
  root 'public#show', page: :home

  get '/c/:id', to: 'shortcodes#show'
  get '/u/:id', to: redirect('/users/%{id}')
  get '/u/:user_id/:id', to: redirect('/users/%{user_id}/%{id}')
  get '/users/:user_id/:id', to: 'characters#show', as: :character

  resources :users, only: [:show] do
    resources :characters, only: [:index, :show] do
      resources :swatches, only: [:index, :create, :update, :destroy]
    end
  end

  # get  '*page', to: 'public#show', formats: :html
end
