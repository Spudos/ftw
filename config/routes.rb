Rails.application.routes.draw do
  resources :articles
  devise_for :users
  resources :turnsheets
  resources :turns
  resources :selections
  resources :clubs
  resources :matches
  resources :fixtures
  resources :clubs, param: :club_id
  resources :admin
  resources :messages
  resources :tactics
  resources :transfers

  root 'welcome#index'

  resources :turnsheets do
    get 'edit', on: :member
    post 'edit', on: :member
  end

  resources :fixtures do
    collection { post :import }
  end

  get '/clubs/manager/club_view', to: 'clubs#club_view'
  get '/clubs/manager/finance', to: 'clubs#finance'
  get '/clubs/manager/first_team', to: 'clubs#first_team'
  get '/clubs/manager/players_contract', to: 'clubs#players_contract'
  get '/clubs/manager/team_statistics', to: 'clubs#team_statistics'
  get '/clubs/manager/team_selection', to: 'clubs#team_selection'
  get '/clubs/manager/results', to: 'clubs#results'
  get '/clubs/manager/fixtures', to: 'clubs#fixtures'
  get '/clubs/manager/history', to: 'clubs#history'

  get '/leagues', to: 'leagues#index'

  get '/leagues/league_cup/league', to: 'leagues#league_cup'
  get '/leagues/wcc/league', to: 'leagues#wcc'

  post '/turnsheets/process_turnsheet', to: 'turnsheets#process_turnsheet'

  post '/selections/auto_selection', to: 'selections#auto_selection'

  post '/turns/process_turn', to: 'turns#process_turn'
  post '/turns/process_player_updates', to: 'turns#process_player_updates'
  post '/turns/process_upgrade_admin', to: 'turns#process_upgrade_admin'
  post '/turns/process_club_updates', to: 'turns#process_club_updates'
  post '/turns/process_article_updates', to: 'turns#process_article_updates'

  post '/matches/match', to: 'matches#match'
  get '/matches/outcome', to: 'matches#outcome'
  post '/matches/save', to: 'matches#save', as: 'save_match'
  get '/matches/:id', to: 'matches#show', as: 'show_match'
  post '/matches/match_multiple', to: 'matches#match_multiple'

  get '/players', to: 'players#index'
  post '/players', to: 'players#create'
  get 'new_player', to: 'players#new'
  get 'edit_player', to: 'players#edit'
  get 'player', to: 'players#show'
  patch '/player', to: 'players#update'
  put '/players/', to: 'players#update'
  delete '/players/', to: 'players#destroy'
  post '/players/potential_update', to: 'players#potential_update'
  get '/players/total_goals', to: 'players#total_goals'
  get '/players/total_assists', to: 'players#total_assists'
  post '/players/sort_players', to: 'players#sort_players', as: 'sort_players'
  get '/players/player_view', to: 'players#player_view'
  get '/players/unmanaged_players', to: 'players#unmanaged_players'
  get '/players/listed_players', to: 'players#listed_players'

  get '/help/rulebook', to: 'help#rulebook'
  get '/help', to: 'help#index'
  get '/help/faq', to: 'help#faq'
  get '/help/issues', to: 'help#issues'
  get '/help/club_creation', to: 'help#club_creation'
end
