Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'

  post 'books/book_search' => 'books#search', as: 'book_search'
  post 'users/user_search' => 'users#search', as: 'user_search'
  resources :books, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update]
  get 'home/about' => 'homes#about' , as: 'about'

end
