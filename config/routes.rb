Rails.application.routes.draw do
  resources :user_test2s
  resources :tests
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
end
