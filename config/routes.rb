Rails.application.routes.draw do
  devise_for :users

  # 1. If the user is logged in, the root of the site is the feed
  authenticated :user do
    root to: "feed#index", as: :authenticated_root
  end

  # 2. Logged out users see the login page
  devise_scope :user do
    unauthenticated :user do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # Feed routes
  get "feed",     to: "feed#index", as: :feed

  # Activity routes (Selection and Redirector)
  resources :activities, only: [ :new, :show ], param: :slug do
    post "like", to: "likes#toggle"
    resources :comments, only: [ :create, :destroy ]
  end

  # Concert routes
  resources :concerts, only: [ :new, :create, :show, :edit, :update, :destroy ], param: :slug do
    collection do
      get :search_artists
      get :search_concerts
    end
  end

  # Other routes
  resources :others, only: [ :new, :create, :show, :edit, :update, :destroy ], param: :slug

  # Hike routes
  resources :hikes, only: [ :new, :create, :show, :edit, :update, :destroy ], param: :slug do
    collection do
      post :parse_gpx
    end
  end

  # Reading routes
  resources :readings, only: [ :new, :create, :show, :edit, :update, :destroy ], param: :slug do
    collection do
      get :search_books
    end
  end

  # User relationships
  resources :users, only: [] do
    member do
      post :follow, to: "follows#create"
      delete :unfollow, to: "follows#destroy"
    end
  end

  resources :goals, only: [ :new, :create, :destroy ]

  # Profile routes
  # Profile routes
  get  "profiles/:username",      to: "profiles#show",   as: :profile
  get  "profiles/:username/edit", to: "profiles#edit",   as: :edit_profile
  patch "profiles/:username",     to: "profiles#update", as: :update_profile

  # Health check (Should remain accessible without login for uptime monitors)
  get "up" => "rails/health#show", as: :rails_health_check
end
