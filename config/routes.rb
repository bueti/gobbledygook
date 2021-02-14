Rails.application.routes.draw do
  devise_for :users

  resources :entries
  resources :users, only: [:index]

  get 'entries/entry'

  root 'static_pages#home'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
