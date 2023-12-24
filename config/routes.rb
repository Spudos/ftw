Rails.application.routes.draw do
  resources :teams, only: [:index, :create]
  root 'welcome#index'
  get :players, to: 'players#index'
end
