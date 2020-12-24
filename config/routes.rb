Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users
  resources :users, :only => [:index, :show]
  root 'home#top'
  get  '/help',    to: 'home#help'
  get  '/about',   to: 'home#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
