Rails.application.routes.draw do
  devise_for :users

  resources :centers, only: [:new, :create, :edit, :update, :destroy]

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/centers/manage", to: "centers#manage_all", as: "manage_centers"

  resources :centers, only: [:index, :show]

  resources :listings, only: [:index, :show] do
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:index, :show, :destroy]
  resources :listings, only: [:destroy]

  get "/trips", to: "listings#index_trips"
  get "/courses", to: "listings#index_courses"
  patch "/bookings/:id/cancel", to: "bookings#cancel", as: "cancel_booking"
end
