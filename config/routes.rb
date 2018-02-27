Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end

  resources :events
  resources :colevents, only: :show do
    resources :messages, only: [:new, :create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
