Rails.application.routes.draw do
  root 'welcome#index'
  get 'show', to: 'welcome#show'
end
