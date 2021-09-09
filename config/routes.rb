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
      get 'followings', to: 'relationships#followings',as: 'followings'
      get 'followers', to: 'relationships#followers' ,as: 'followers'
    end
      get 'members/:id/unsubscribe', to: 'members#unsubscribe',as: 'unsubscribe'
      patch 'members/:id/withdraw', to: 'members#withdraw',as: 'withdraw'

    resources :requests do
      resource :like, only:[:create,:destroy]
      resources :comments, only:[:create,:destroy]
    end
    
    resources :tags do
      get 'requests', to: 'requests#search'
    end  
  end

end
