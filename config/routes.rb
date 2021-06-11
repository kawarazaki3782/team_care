Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  resources :users
  post '/signup' => 'users#confirm'
end
