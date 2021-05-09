Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api do
    resources :movies, only: [:index]
    resources :subscriptions, only: [:create]
  end
end
