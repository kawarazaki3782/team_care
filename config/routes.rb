Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  post '/signup' => 'users#confirm'
  patch '/users/:id/edit' => 'users#verification'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get '/users_path', to: 'users#index'
  get '/users/:userid', to: 'users#index'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:index, :show, :create, :destroy]
  resources :microposts do
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships,   only: [:create, :destroy]
end
