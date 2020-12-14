Rails.application.routes.draw do
  root 'home#top'
  get  '/help',    to: 'home#help'
  get  '/about',   to: 'home#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
