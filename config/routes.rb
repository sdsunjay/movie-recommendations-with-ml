Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # static pages
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'

  devise_scope :user do
    get '/sign-in', to: 'devise/sessions#new', as: :signin
    get '/sign-up', to: 'devise/registrations#new', as: :signup
    authenticated :user do
      resources :users, only: %i[show edit destroy update]
      resources :friendships, only: %i[new create]
      root to: 'movies#index', as: :authenticated_root
      resources :genres, only: [:show]
      get 'movies/:movie_id/reviews/create', to: 'reviews#create', via: :post
      resources :movies, only: %i[index show] do
        resources :reviews, only: %i[new create edit update destroy]
      end
    end

    unauthenticated do
      root to: 'devise/registrations#new', as: :unauthenticated_root
    end

    authenticate :user, ->(user) { user.super_admin? } do
      mount Blazer::Engine, at: 'blazer'
      resources :users, only: [:index]
      resources :genres, only: %i[index new create edit update]
      resources :reviews, only: [:index]
      resources :movies, only: %i[new create edit update destroy]
      resources :friendships, only: %i[index show edit destroy update]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
