# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :admins do
    resources :members, only: %i[index show edit update]
    resources :requests, only: [:index,:show,:edit,:update]
    resources :contacts, only: [:index,:edit,:update]
  end

  devise_for :members, controllers: {
    sessions: 'members/sessions',
    passwords: 'members/passwords',
    registrations: 'members/registrations'
  }

  scope module: :members do
    root to: 'homes#top'
    get '/about', to: 'homes#about'
    get '/guide', to: 'homes#guide'
    get '/search', to: 'searches#search'

    resources :members, only: %i[show edit update] do
      resource :relationships, only: %i[create destroy]
      get 'followings', to: 'relationships#followings', as: 'followings'
      get 'followers', to: 'relationships#followers', as: 'followers'
    end
    get 'members/:id/unsubscribe', to: 'members#unsubscribe', as: 'unsubscribe'
    patch 'members/:id/withdraw', to: 'members#withdraw', as: 'withdraw'
    get 'members/:id/main', to: 'members#main', as: 'main'

    resources :requests do
      resource :like, only: %i[create destroy]
      resources :comments, only: %i[create destroy]
      resources :rates, only: [:create, :new]
      patch :is_active_release
    end
    get 'requests/tagshow/:name', to: 'requests#tagshow', as: 'tagshow'

    resources :chats, only: %i[create]
    resources :rooms, only: %i[index show]
    resources :notifications, only: [:index]
    delete 'notifications/destroy_all', to: 'notifications#destroy_all', as: 'destroy_all_notifications'

    resources :contacts, only: [:new,:create]

  end
end
