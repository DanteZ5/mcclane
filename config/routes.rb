Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable"

  devise_for :users

  devise_scope :user do
    get 'login', to: "pages#home"
  end

  root to: "pages#guide"

  resources :collaborators, except: [:index] do
    collection do
      get :count
      get :index
      post :import
    end
  end

  resources :events do
    member do
      patch 'close'
      patch 'edit_messages'
    end
  end


  resources :colevents, only: [:show, :update] do
    resources :messages, only: [:new, :create]
    get '/mark_unsafe', to: 'colevents#mark_unsafe'
    get '/mark_suspect', to: 'colevents#mark_suspect'
  end


  get 'messages/create'

  get '/subscription', to: 'pages#subscription'
  get '/thanks', to: 'pages#thanks'
  post '/subscription', to: 'pages#create'



  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/listen", to: "/api/v1/messages#listen"

      resources :templates, only: [] do
        member do
          post :voice
        end
      end
    end
  end
end
