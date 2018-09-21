Rails.application.routes.draw do
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  resources :users, only: [:index, :show, :edit, :destroy, :update]
  devise_scope :user do
  authenticated :user do

    # resources :users, only: [:index, :show, :edit, :destroy, :update]
    root to: 'movies#index', as: :authenticated_root
    resources :genres, only: [:index,:show, :new, :create, :edit, :update]
    get 'movies/:id/like', to: 'movies#like', as: :movie_like
    get 'movies/:id/dislike', to: 'movies#dislike', as: :movie_dislike
    resources :reviews, only: [:index]
    resources :movies, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    end
  end

  unauthenticated do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
