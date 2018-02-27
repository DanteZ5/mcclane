Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'events#new', as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  resources :events
  resources :colevents, only: :show do
    resources :messages, only: [:new, :create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
