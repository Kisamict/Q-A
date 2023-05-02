Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  concern :votable do
    post :vote_up, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, except: [:edit]
  end
  
  resources :attachments, only: :destroy

  patch 'mark_best_answer/:id', to: 'answers#mark_best', as: 'answers_mark_best'
end
