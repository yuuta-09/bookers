Rails.application.routes.draw do
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
    get "search", to: "users#search"
  end
  resources :groups, except: [:destroy] do
    get 'join' => 'groups#join'
    delete 'leave' => 'groups#leave'
    get 'notice' => 'groups#new_mail'
    post 'send' => 'groups#send_mail'
  end
  get '/search', to: 'searches#search'

  resources :chats, only: [:show, :create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
