Rails.application.routes.draw do
  resources :exchanges
  resources :incomes
  resources :records
  resources :expenditures
  resources :projects
  resources :events
  resources :orders do
    collection do
      get 'canceled'
      get 'executed'
    end
  end
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  get 'order_file/:id', to: 'orders#download_file', as: 'order_file'
  delete 'order_file/:id', to: 'orders#delete_file'
  get 'record_file/:id', to: 'records#download_file', as: 'record_file'
  delete 'record_file/:id', to: 'records#delete_file'
  get 'exchange_file/:id', to: 'exchanges#download_file', as: 'exchange_file'
  delete 'exchange_file/:id', to: 'exchanges#delete_file'

  root to: 'orders#index'
  devise_for :users
  resources :users
end
