Rails.application.routes.draw do
  get 'favorites/index'
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
  get  '/about',   to: 'static_pages#about'
  
  resources :users do
    member do
      get :following, :followers, :users_microposts
      get :following, :followers, :users_diaries
    end
  end

  get "following_microposts" => "microposts#following_microposts"
  get "following_diaries" => "diaries#following_diaries"
  
  resources :diaries do
    collection do
      get :draft
    end            
  end
  
  resources :microposts, only: [:index, :show, :create, :destroy, :new]
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
  post 'guest_login', to: "guest_sessions#create"
  resources :categories

  resources :users, only: [:index, :show]
  resources :microposts, only: [:index, :show, :create] do
    resources :likes, only: [:create, :destroy]
  end
  resources :diaries, only: [:index, :show, :create, :destroy, :new]

  resources :diaries, only: [:index, :show, :create] do
    resources :likes, only: [:create, :destroy]
  end

  resources :diaries do
    resources :comments, only: [:create, :destroy]
  end

  resources :microposts do
    post 'add' => 'favorites#create'
    delete '/add' => 'favorites#destroy'
  end

  resources :diaries do
    post 'add' => 'favorites#create'
    delete '/add' => 'favorites#destroy'
  end

  resources :favorites
  resources :messages, :only => [:create, :destroy]
  resources :rooms, :only => [:create, :show, :index]
  resources :notifications, :only => [:index, :destroy]
  delete '/notifications',  to: 'notifications#destroy'

  resources :users do
    member do
      get :blocking, :blockers
    end
  end
resources :blocks, only: [:create, :destroy]

end
