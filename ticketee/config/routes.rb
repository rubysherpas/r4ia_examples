Rails.application.routes.draw do
  namespace :admin do
    root "application#index"

    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
    resources :states, only: [:index, :new, :create] do
      member do
        get :make_default
      end
    end
  end

  devise_for :users
  root "projects#index"

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets
  end

  resources :tickets, only: [] do
    resources :comments, only: [:create]
  end

  resources :attachments, only: [:show, :new]
end
