Diploma::Application.routes.draw do
  devise_for :users

  root to: 'static#dashboard'

  resources :users do
    member do
      get :block
      get :unblock
      get :list_tasks
      get :show_statistics
    end
    collection do
      post :blocked
      get :blocked
    end
    resources :weekly_surveys
  end

  resources :projects do
  end
  resources :tasks

  #resources :project_montly_incomes
  delete 'users/:id/delete_avatar', to: 'users#delete_avatar', as: :delete_avatar
  delete 'projects/:id/delete_logo', to: 'project#delete_logo', as: :delete_logo
  patch 'task/:id/change_status', to: 'tasks#change_status', as: :change_status
  get 'blocked', to: 'static#blocked', as: :blocked
  get 'task_assign_adviser', to: 'static#task_adviser', as: :task_adviser
end
