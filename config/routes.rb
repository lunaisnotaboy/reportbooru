Rails.application.routes.draw do
  resources :hits, only: [:create, :show]
  resources :post_views, only: [:create, :show]
  resources :post_searches, only: [:create, :show]
  resource :missed_searches, only: [:create, :show]
  resource :user_searches, only: [:show]

  get "reports/uploads", to: "reports#uploads"
  get "reports/status", to: "reports#status"
end
