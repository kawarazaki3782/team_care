Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  post '/signup' => 'users#confirm'
  post '/users/:id/edit' => 'users#verification'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get '/users_path', to: 'users#index'
  get '/users/:userid', to: 'users#index'
end