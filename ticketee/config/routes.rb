Rails.application.routes.draw do
  root "projects#index"

  resources :projects
end