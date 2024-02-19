Rails.application.routes.draw do
  devise_for :users
  resources :turnsheets
  resources :turns
  resources :selections
  resources :clubs
  resources :matches
  resources :fixtures
  resources :clubs, param: :club_id
  resources :leagues, param: :competition
  resources :admin
  resources :messages
  resources :tactics
  resources :transfers

  root 'welcome#index'

  resources :turnsheets do
    get 'edit', on: :member
    post 'edit', on: :member
  end

  get '/clubs/manager/club_view', to: 'clubs#club_view'
  get '/clubs/manager/first_team', to: 'clubs#first_team'
  get '/clubs/manager/players_contract', to: 'clubs#players_contract'
  get '/clubs/manager/team_statistics', to: 'clubs#team_statistics'
  get '/clubs/manager/team_selection', to: 'clubs#team_selection'
  get '/clubs/manager/results', to: 'clubs#results'
  get '/clubs/manager/fixtures', to: 'clubs#fixtures'
  get '/clubs/manager/history', to: 'clubs#history'

  get '/leagues/premier/table', to: 'leagues#premier_league_table'
  get '/leagues/premier/statistics', to: 'leagues#premier_league_statistics'
  get '/leagues/premier/fixtures', to: 'leagues#premier_league_fixtures'
  get '/leagues/championship/table', to: 'leagues#championship_league_table'
  get '/leagues/championship/statistics', to: 'leagues#championship_league_statistics'
  get '/leagues/championship/fixtures', to: 'leagues#championship_league_fixtures'
  get '/leagues/ligue_1/table', to: 'leagues#ligue_1_league_table'
  get '/leagues/ligue_1/statistics', to: 'leagues#ligue_1_statistics'
  get '/leagues/ligue_1/fixtures', to: 'leagues#ligue_1_fixtures'
  get '/leagues/ligue_2/table', to: 'leagues#ligue_2_league_table'
  get '/leagues/ligue_2/statistics', to: 'leagues#ligue_2_statistics'
  get '/leagues/ligue_2/fixtures', to: 'leagues#ligue_2_fixtures'
  get '/leagues/bundesliga_1/table', to: 'leagues#bundesliga_1_league_table'
  get '/leagues/bundesliga_1/statistics', to: 'leagues#bundesliga_1_statistics'
  get '/leagues/bundesliga_1/fixtures', to: 'leagues#bundesliga_1_fixtures'
  get '/leagues/bundesliga_2/table', to: 'leagues#bundesliga_2_league_table'
  get '/leagues/bundesliga_2/statistics', to: 'leagues#bundesliga_2_statistics'
  get '/leagues/bundesliga_2/fixtures', to: 'leagues#bundesliga_2_fixtures'
  get '/leagues/la_liga/table', to: 'leagues#la_liga_league_table'
  get '/leagues/la_liga/statistics', to: 'leagues#la_liga_statistics'
  get '/leagues/la_liga/fixtures', to: 'leagues#la_liga_fixtures'
  get '/leagues/segunda_division/table', to: 'leagues#segunda_division_league_table'
  get '/leagues/segunda_division/statistics', to: 'leagues#segunda_division_statistics'
  get '/leagues/segunda_division/fixtures', to: 'leagues#segunda_division_fixtures'
  get '/leagues/serie_a/table', to: 'leagues#serie_a_league_table'
  get '/leagues/serie_a/statistics', to: 'leagues#serie_a_statistics'
  get '/leagues/serie_a/fixtures', to: 'leagues#serie_a_fixtures'
  get '/leagues/serie_b/table', to: 'leagues#serie_b_league_table'
  get '/leagues/serie_b/statistics', to: 'leagues#serie_b_statistics'
  get '/leagues/serie_b/fixtures', to: 'leagues#serie_b_fixtures'
  get '/leagues/brasileiro_serie_a/table', to: 'leagues#brasileiro_serie_a_league_table'
  get '/leagues/brasileiro_serie_a/statistics', to: 'leagues#brasileiro_serie_a_statistics'
  get '/leagues/brasileiro_serie_a/fixtures', to: 'leagues#brasileiro_serie_a_fixtures'
  get '/leagues/brasileiro_serie_b/table', to: 'leagues#brasileiro_serie_b_league_table'
  get '/leagues/brasileiro_serie_b/statistics', to: 'leagues#brasileiro_serie_b_statistics'
  get '/leagues/brasileiro_serie_b/fixtures', to: 'leagues#brasileiro_serie_b_fixtures'

  get '/leagues/cup/league', to: 'leagues#league_cup'

  post '/turnsheets/process_turnsheet', to: 'turnsheets#process_turnsheet'

  post '/turns/process_turn', to: 'turns#process_turn'
  post '/turns/process_player_updates', to: 'turns#process_player_updates'
  post '/turns/process_upgrade_admin', to: 'turns#process_upgrade_admin'

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
end
