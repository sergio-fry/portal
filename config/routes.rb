# frozen_string_literal: true

Rails.application.routes.draw do
  get 'admin', to: 'admin#index'

  devise_for :users
  resources :pages, except: %i[new create] do
    collection do
      post :rebuild
    end
    member do
      get :history
    end
  end

  root 'pages#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
