Rails.application.routes.draw do
  get "admin", to: "admin#index"

  devise_for :users
  resources :pages, except: [:new, :create] do
    collection do
      post :rebuild
    end
  end

  root "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
