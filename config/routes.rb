Rails.application.routes.draw do
  get "home/index"
  get "help-center", to: "home#help_center", as: :help_center
  get "contact", to: "home#contact", as: :contact
  get "change_locale/:locale", to: "home#change_locale", as: :change_locale
  get "change_currency/:currency", to: "home#change_currency", as: :change_currency
  devise_for :users
  root "skus#index"
  
  resources :categories, only: [:show]
  resources :skus, only: [:index, :show]
  resource :cart, only: [:show]
  resources :orders, only: [:index, :show, :new, :create] do
    member do
      post :pay
      post :cancel
    end
  end
  resources :cart_items, only: [:create, :update, :destroy]
  
  # Account routes (Ordinary user backend)
  namespace :account do
    root "orders#index", as: :root
    resources :orders, only: [:index, :show]
  end

  # Admin routes
  namespace :admin do
    root "dashboard#index", as: :root
    get "dashboard", to: "dashboard#index", as: :dashboard
    resources :categories
    resources :skus do
      member do
        delete :delete_image
      end
    end
    resources :orders, only: [:index, :show] do
      member do
        post :ship
        post :complete
        post :cancel
      end
    end
    resources :visitors, only: [:index] do
      collection do
        delete :destroy_all
        delete :clean_old
      end
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
