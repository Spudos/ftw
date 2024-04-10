Rails.application.routes.draw do
  resources :articles
  devise_for :users
  resources :turnsheets
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

  get '/feedback/new', to: 'feedback#new', as: 'new_feedback'
  post '/feedback', to: 'feedback#create', as: 'create_feedback'
  get '/feedback/close_feedback', to: 'feedback#close_feedback'

  get '/clubs/manager/club_view', to: 'clubs#club_view'
  get '/clubs/manager/finance', to: 'clubs#finance'
  get '/clubs/manager/first_team', to: 'clubs#first_team'
  get '/clubs/manager/players_contract', to: 'clubs#players_contract'
  get '/clubs/manager/team_statistics', to: 'clubs#team_statistics'
  get '/clubs/manager/results', to: 'clubs#results'
  get '/clubs/manager/fixtures', to: 'clubs#fixtures'
  get '/clubs/manager/history', to: 'clubs#history'

  get '/leagues', to: 'leagues#index'

  get '/users', to: 'users#index'
  get '/users/resign', to: 'users#resign'
  get '/users/new_manager', to: 'users#new_manager'

  get '/leagues/league_cup/league', to: 'leagues#league_cup'
  get '/leagues/wcc/league', to: 'leagues#wcc'
  post '/leagues/create_tables', to: 'leagues#create_tables'

  post '/turnsheets/process_turnsheet', to: 'turnsheets#process_turnsheet'

  post '/selections/auto_selection', to: 'selections#auto_selection'

  post '/turns/process_turn', to: 'turns#process_turn'
  post '/turns/process_player_updates', to: 'turns#process_player_updates'
  post '/turns/process_upgrade_admin', to: 'turns#process_upgrade_admin'
  post '/turns/process_club_updates', to: 'turns#process_club_updates'
  post '/turns/process_article_updates', to: 'turns#process_article_updates'

  get '/turns/gm_admin', to: 'turns#gm_admin'
  get '/turns', to: 'turns#index'
  post '/turns', to: 'turns#create'
  get 'new_turn', to: 'turns#new'
  get 'edit_turn/:id', to: 'turns#edit', as: 'edit_turn'
  get 'turn', to: 'turns#show'
  patch 'turn', to: 'turns#update'
  put 'turn', to: 'turns#update'
  delete 'turn/:id', to: 'turns#destroy'

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
  get '/players/player_value_update', to: 'players#player_value_update'
  get '/players/adjust_duplicate_names', to: 'players#adjust_duplicate_names'

  get '/help/rulebook', to: 'help#rulebook'
  get '/help', to: 'help#index'
  get '/help/faq', to: 'help#faq'
  get '/help/issues', to: 'help#issues'
  get '/help/club_creation', to: 'help#club_creation'
  get '/help/manage', to: 'help#manage'
  get '/help/manager_list', to: 'help#manager_list'
  get '/help/roadmap', to: 'help#roadmap'
  post '/help/club_submission', to: 'help#club_submission'

  get '/turn_report', to: 'turn_report#index'
end
