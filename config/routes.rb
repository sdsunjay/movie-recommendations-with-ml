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
      resources :users, only: [:index, :show, :edit, :destroy, :update]
      resources :friendships, only: [:new, :create, :index, :show, :edit, :destroy, :update]
      root to: 'movies#index', as: :authenticated_root
      resources :genres, only: [:show, :index, :new, :create, :edit, :destroy, :update]
      get 'movies/:movie_id/reviews/create', to: 'reviews#create', via: :post
      resources :reviews, only: [:index]
      resources :movies, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        resources :reviews, only: [:new, :create, :edit, :update, :destroy]
      end
    end

    unauthenticated do
      root to: 'devise/registrations#new', as: :unauthenticated_root
    end

    # TODO - why doesn't this work???
    authenticate :user, ->(user) { user.super_admin? } do
      mount Blazer::Engine, at: 'blazer'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
