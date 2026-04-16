Rails.application.routes.draw do
  root "dashboard#index"
  get "/dashboard", to: "dashboard#index"

  resources :bookings
  resources :customers

  get "/inventory", to: "inventory#edit"
  patch "/inventory", to: "inventory#update"

  get "/availability", to: "availability#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
