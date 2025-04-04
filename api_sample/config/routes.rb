Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      get '/me', to: 'sessions#me'
      resources :users, only: [:show]
      post '/users/:id/follow', to: 'follows#create'
      post '/users/:id/unfollow', to: 'follows#destroy'
      resources :posts, only: %i[index create]
      post '/posts/:id/like', to: 'likes#create'
      post '/posts/:id/unlike', to: 'likes#destroy'
    end
  end
end
