Rails.application.routes.draw do
  get 'inquiry/index'
  get 'inquiry/confirm'
  get 'inquiry/thanks'
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
  get  '/about',   to: 'static_pages#about'
  get  '/mypage',   to: 'static_pages#mypage'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:index, :show, :create, :destroy,]
  resources :microposts do
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships,   only: [:create, :destroy]
  resources :microposts do
    collection do
      match 'search' => 'microposts#search', via: %i[get post]
  end
end
  get   'inquiry'         => 'inquiry#index'     
  post  'inquiry/confirm' => 'inquiry#confirm'   
  post  'inquiry/thanks'  => 'inquiry#thanks'    
end
