Rails.application.routes.draw do
  devise_for :users

  resources :entries

  get 'entries/entry'

  root 'static_pages#home'
end
