Rails.application.routes.draw do
  root 'welcome#index'
  get 'index', to: 'players#index'
  get 'load_team', to: 'team#load_team'
  get '/team/load_team', to: 'team#load_team'
end
