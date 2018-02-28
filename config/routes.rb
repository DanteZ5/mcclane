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
  resources :colevents, only: :show do
    resources :messages, only: [:new, :create]
  end


  # route temporaire a supprimer a la fin. utilisee pour test Twilio
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
