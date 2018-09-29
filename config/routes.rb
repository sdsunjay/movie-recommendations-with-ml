Rails.application.routes.draw do
  devise_for :users, :controllers => {omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions', registrations: 'users/registrations'}
  # static pages
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'


  devise_scope :user do
    authenticated :user do
      resources :users, only: [:show, :edit, :destroy, :update ]
      resources :friendships, only: [:new, :create]
      root to: 'movies#index', as: :authenticated_root
      resources :genres, only: [:show]
      get 'movies/:id/like', to: 'movies#like', as: :movie_like
      get 'movies/:id/dislike', to: 'movies#dislike', as: :movie_dislike
      resources :movies, only: [:index, :show] do
        resources :reviews, only: [:new, :create, :edit, :update, :destroy]
      end
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end

    authenticate :user, ->(user) {user.super_admin?} do
     mount Blazer::Engine, at: "blazer"
     resources :users, only: [:index]
     resources :genres, only: [:index, :new, :create, :edit, :update]
     resources :reviews, only: [:index]
     resources :movies, only: [:new, :create, :edit, :update, :destroy]
     resources :friendships, only: [:index, :show, :edit, :destroy, :update]
    end

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
