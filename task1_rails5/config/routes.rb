Rails.application.routes.draw do
  root 'welcome#index'
  get 'time' => 'time#index', as: :time
end
