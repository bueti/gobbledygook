Rails.application.routes.draw do
  devise_for :users

  resources :entries do
    collection do
      get  'entry'
      get  'drafts'
      post 'create_draft'
    end
  end
  resources :users, only: [:index, :edit, :show, :update]

  get 'about',          to: 'static_pages#about'
  get 'privacy_policy', to: 'static_pages#privacy'
  get 'license',        to: 'static_pages#license'

  root 'static_pages#home'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
