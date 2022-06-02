Rails.application.routes.draw do
  # mailer
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

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
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search', to: 'searches#search'

  # DM
  resources :users, only: [:show,:edit,:update]
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]

  # search post count by calender
  post '/search_by_calender' => 'books#search_by_calender'

  # group
  resources :groups do
    post 'join_group' => 'groups#join_group'
    # event mail
    get '/new_event' => 'groups#notice_event'
    post '/new_event' => 'groups#create_event_mail'
    get '/confirm_mail' => 'groups#confirm_mail'
  end


end
