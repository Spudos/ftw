Rails.application.routes.draw do
  resources :players
  resources :matches
  resources :fixtures
  post '/matches/match', to: 'matches#match'
  get '/matches/outcome', to: 'matches#outcome'
  post '/matches/save', to: 'matches#save', as: 'save_match'
  root 'welcome#index'
end