Rails.application.routes.draw do
  resources :selections
  resources :clubs
  resources :players
  resources :matches
  resources :fixtures
  resources :clubs, param: :abbreviation
  resources :leagues
  post '/matches/match', to: 'matches#match'
  get '/matches/outcome', to: 'matches#outcome'
  post '/matches/save', to: 'matches#save', as: 'save_match'
  get '/matches/:match_id', to: 'matches#show', as: 'show_match'
  post '/matches/match_multiple', to: 'matches#match_multiple'
  root 'welcome#index'
  get '/players/total_goals', to: 'players#total_goals'
  get '/players/total_assists', to: 'players#total_assists'
end