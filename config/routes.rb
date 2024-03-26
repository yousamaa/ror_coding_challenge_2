Rails.application.routes.draw do
  root to: 'api/tasks#index'

  namespace :api do
    resources :tasks, only: [:index, :update, :create, :destroy] do
      member do
        post :assign, to: 'tasks#assign'
        put :progress, to: 'tasks#progress'
      end
      collection do
        get :overdue
        get :by_status, path: 'status/:status', action: :status
        get :completed
        get :statistics
        get :priority_queue
      end
    end
    resources :users, only: [:create] do
      member do
        get :tasks
      end
    end
  end
end
