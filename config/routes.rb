Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :centers

  resources :listings, only: [:index, :show] do
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:index, :show, :destroy]
  resources :listings, only: [:destroy]

  get "/trips", to: "listings#index_trips"
  get "/courses", to: "listings#index_courses"
  patch "/bookings/:id/cancel", to: "bookings#cancel", as: "cancel_booking"
end
