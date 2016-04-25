Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get 'front', to: 'pages#front'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'

  resources :relationships, only: [:create, :destroy]

  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  resources :categories, only: [:show]
  resources :users, except: [:index, :destroy]
  resources :sessions, only: [:new, :create]

end
