Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :centers
  resources :listings
  resources :bookings

  get "/trips", to: "listings#index_trips"
  get "/courses", to: "listings#index_courses"
end
