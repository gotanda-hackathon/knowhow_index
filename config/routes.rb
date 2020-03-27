Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'toppage#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  concern :csv_importable do
    collection do
      post :csv_import
    end
  end

  resources :companies do
    resources :users, expect: [:show], concerns: :csv_importable
    resources :ad_media, expect: [:show], concerns: :csv_importable
    resources :categories, expect: [:show], concerns: :csv_importable
    resources :clients, expect: [:show]
  end

  namespace :admin do
    resources :companies, expect: [:show]
    resources :users, expect: [:show]
  end

  match '*path', to: 'application#error404', via: :all
end
