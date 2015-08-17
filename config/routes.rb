Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'front', to: 'users#front'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
  resources :users, except: [:index, :destroy]

end
