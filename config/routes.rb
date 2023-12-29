Rails.application.routes.draw do
  resources :selections
  resources :clubs
  resources :players
  resources :matches
  resources :fixtures
  resources :clubs, param: :abbreviation
  post '/matches/match', to: 'matches#match'
  get '/matches/outcome', to: 'matches#outcome'
  post '/matches/save', to: 'matches#save', as: 'save_match'
  get '/matches/:match_id', to: 'matches#show', as: 'show_match'
  root 'welcome#index'
end