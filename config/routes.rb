Rails.application.routes.draw do
  devise_for :users

  resources :centers, only: [:new, :create, :edit, :update, :destroy]

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/centers/manage", to: "centers#manage_centers", as: "manage_centers"
  get "/centers/:center_id/listings/manage", to: "listings#manage_listings", as: "manage_listings"

  resources :centers, only: [:index, :show] do
    resources :listings, only: [:new, :create]
  end

  resources :listings, only: [:index, :show] do
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:index, :show, :destroy]
  resources :listings, only: [:edit, :update, :destroy]

  get "/trips", to: "listings#index_trips"
  get "/courses", to: "listings#index_courses"
  patch "/bookings/:id/cancel", to: "bookings#cancel", as: "cancel_booking"
  get "/bookings/:id/export.pdf", to: "bookings#export", as: "export_booking"
end
