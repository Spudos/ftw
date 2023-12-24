Rails.application.routes.draw do
  root 'welcome#index'
  get 'index', to: 'players#index'
end
