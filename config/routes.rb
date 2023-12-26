Rails.application.routes.draw do
  resources :players
  get '/matches', to: 'matches#match', as: 'match'
  root 'welcome#index'
end