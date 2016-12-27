Rails.application.routes.draw do
  root 'public#show', page: :home

  get '/c/:id', to: 'shortcodes#show'
  get '/u/:id', to: redirect('/users/%{id}')
  get '/u/:user_id/c/:id', to: redirect('/users/%{user_id}/characters/%{id}')
  get '/users/:user_id/c/:id', to: redirect('/users/%{user_id}/characters/%{id}')

  resources :users, only: [:show] do
    resources :characters, only: [:show]
  end

  # get  '*page', to: 'public#show', formats: :html
end
