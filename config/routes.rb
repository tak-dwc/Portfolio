Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :admins do
    resources :members, only:[:index,:show,:edit,:update]
  end

  devise_for :members, controllers: {
    sessions:      'members/sessions',
    passwords:     'members/passwords',
    registrations: 'members/registrations'
  }

  scope module: :members do

    root to: 'homes#top'
    get '/about',to: 'homes#about'
    get '/guide',to: 'homes#guide'
    get '/search', to: 'searches#search'

    resources :members, only: [:show, :edit, :update] do
      resource :relationships, only: [:create,:destroy]
      get 'followings' => 'relationships#followings',as: 'followings'
      get 'followers' => 'relationships#followers' ,as: 'followers'
    end
    get 'members/main', to: 'members#main'
    get 'members/unsubscribe', to: 'members#unsubscribe'
    patch 'members/withdraw', to: 'members#withdraw'

    resources :requests do
      resource :like, only:[:create,:destroy]
      resources :comments, only:[:create,:destroy]
    end
    get 'requests/main', to: 'requests#main'
  end

end
