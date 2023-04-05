Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: [:edit]
  end
  
  resources :attachments, only: :destroy

  patch 'mark_best_answer/:id', to: 'answers#mark_best', as: 'answers_mark_best'
end
