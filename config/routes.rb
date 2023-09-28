Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  concern :votable do
    post :vote_up, on: :member
    post :vote_down, on: :member
    delete :revote, on: :member
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, except: [:edit], concerns: [:votable, :commentable], shallow: true
  end
  
  resources :attachments, only: :destroy

  patch 'mark_best_answer/:id', to: 'answers#mark_best', as: 'answers_mark_best'

  mount ActionCable.server => '/cable'
end
