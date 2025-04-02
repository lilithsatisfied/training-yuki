Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      get '/me', to: 'sessions#me'
      resources :users, only: [:show]
    end
  end
end
