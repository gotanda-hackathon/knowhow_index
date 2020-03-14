Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'toppage#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :companies do
    resources :users, expect: [:show]
    resources :ad_media, expect: [:show]
  end

  namespace :admin do
    resources :companies, expect: [:show]
    resources :users, expect: [:show]
  end

  match '*path', to: 'application#error404', via: :all
end
