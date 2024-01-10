Rails.application.routes.draw do
  devise_for :users
  resources :turnsheets
  resources :turns
  resources :selections
  resources :clubs
  resources :players
  resources :matches
  resources :fixtures
  resources :clubs, param: :abbreviation
  resources :leagues
  resources :admin
  resources :messages

  root 'welcome#index'

  post '/turnsheets/process_turnsheet', to: 'turnsheets#process_turnsheet'

  resources :turnsheets do
    get 'edit', on: :member
    post 'edit', on: :member
  end

  post '/turns/process_turn', to: 'turns#process_turn'  
  post '/matches/match', to: 'matches#match'
  get '/matches/outcome', to: 'matches#outcome'
  post '/matches/save', to: 'matches#save', as: 'save_match'
  get '/matches/:match_id', to: 'matches#show', as: 'show_match'
  post '/matches/match_multiple', to: 'matches#match_multiple'
  
  post '/players/potential_update', to: 'players#potential_update'
  get '/players/total_goals', to: 'players#total_goals'
  get '/players/total_assists', to: 'players#total_assists'
  post '/players/sort_players', to: 'players#sort_players', as: 'sort_players'
end
