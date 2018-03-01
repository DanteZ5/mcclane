Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'messages/create'

  devise_for :users
  root to: "events#new"

  devise_scope :user do
    get 'login', to: "pages#home"
  end

  resources :events
  resources :colevents, only: [:show, :update] do
    resources :messages, only: [:new, :create]
  end


  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "/listen", to: "/api/v1/messages#listen"
      resources :messages, only: [:show]
    end
  end
  # get "api/v1/stuff", to: "/api/v1/messages#stuff"


  # get 'listen', to: "messages#listen", as: 'listen'

  # route temporaire a supprimer a la fin. utilisee pour test Twilio
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
