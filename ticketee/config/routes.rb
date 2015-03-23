Rails.application.routes.draw do
  namespace :admin do
    root "application#index"

    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  devise_for :users
  root "projects#index"

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets
  end
end
