Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'messages/create'

  mount ActionCable.server => "/cable"

  devise_for :users
  root to: "events#new"

  devise_scope :user do
    get 'login', to: "pages#home"
  end

  resources :collaborators, only: [] do
    collection do
      get :count
      get :index
      post :import
    end
  end

  resources :events do
    member do
      patch 'close'
    end
  end


  resources :colevents, only: [:show, :update] do
    resources :messages, only: [:new, :create]
    get '/mark_unsafe', to: 'colevents#mark_unsafe'
    get '/mark_suspect', to: 'colevents#mark_suspect'
  end





  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/listen", to: "/api/v1/messages#listen"
    end
  end
end
