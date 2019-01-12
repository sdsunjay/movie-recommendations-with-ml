Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # static pages
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'
  get 'facebook/subscription', to: 'facebook_realtime_updates#subscription', as: 'facebook_subscription', via: [:get,:post]

  devise_scope :user do
    get '/sign-in', to: 'devise/sessions#new', as: :signin
    get '/sign-up', to: 'devise/registrations#new', as: :signup
    resources :contacts, only: [:new, :create]
    authenticated :user do
      resources :states
      resources :countries
      resources :cities do
        collection do
          get 'search'
        end
      end
      resources :educations, only: [:show, :index, :new, :create, :edit, :destroy, :update] do
        collection do
          get 'search'
        end
      end
      get '/search', to: 'search#search', as: 'search'
      get '/autocomplete/search', to: 'search#autocomplete', as: 'autocomplete_search'
      get '/autocomplete/education', to: 'educations#autocomplete', as: 'autocomplete_education'
      get '/autocomplete/city', to: 'cities#autocomplete', as: 'autocomplete_city'
      resources :users, only: [:index, :show, :edit, :destroy, :update]
      resources :friendships, only: [:new, :create, :index, :show, :edit, :destroy, :update]
      root to: 'movies#index', as: :authenticated_root
      resources :genres, only: [:show, :index, :new, :create, :edit, :destroy, :update]
      resources :companies, only: [:show, :index, :new, :create, :edit, :destroy, :update]
      match 'users/liked/:id' => 'users#liked', as: :user_liked, via: [:get, :post]
      match 'users/disliked/:id' => 'users#disliked', as: :user_disliked, via: [:get, :post]
      resources :movie_user_recommendations, only: [:new, :create, :index, :show, :edit, :destroy, :update]
      resources :movies, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        resources :reviews, only: [:new, :create, :edit, :update, :destroy]
      end
    end

    unauthenticated do
      root to: 'devise/registrations#new', as: :unauthenticated_root
      resources :movies, only: [:index]
    end

    authenticate :user, ->(user) { user.super_admin? } do
      mount Blazer::Engine, at: 'blazer'
      resources :reviews, only: [:index]
      resources :contacts, only: [:index, :show, :destroy]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
