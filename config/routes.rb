Rails.application.routes.draw do
  namespace :admin do
    get 'members/index'
    get 'members/show'
    get 'members/edit'
  end
  namespace :public do
    get 'requests/new'
    get 'requests/index'
    get 'requests/show'
    get 'requests/edit'
  end
  namespace :public do
    get 'members/main'
    get 'members/show'
    get 'members/edit'
    get 'members/unsubscribe'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
    get 'homes/guide'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
