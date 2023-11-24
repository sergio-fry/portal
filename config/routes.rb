# frozen_string_literal: true

Rails.application.routes.draw do
  get 'ipfs/:cid(.:format)', to: 'ipfs#show', as: :ipfs
  get 'ipfs/:cid/:filename(.:format)', to: 'ipfs#folder'
  get 'healthcheck', to: 'healthcheck#index'
  get 'admin', to: 'admin#index'

  devise_for :users, class_name: 'Boundaries::Database::User'
  resources :pages do
    collection do
      post :rebuild
    end
  end

  root 'pages#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
