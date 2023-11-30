Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } 

  devise_scope :user do
    get 'enter_email', to: 'omniauth_callbacks#enter_email', as: 'omniauth_enter_email'
    post 'create_auth', to: 'omniauth_callbacks#create_auth', as: 'omniauth_create_auth'
  end

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, shallow: true, only: [:index, :show, :create]
      end
    end
  end
  
  concern :votable do
    post :vote_up, on: :member
    post :vote_down, on: :member
    delete :revote, on: :member
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, except: [:edit], concerns: [:votable, :commentable], shallow: true
    resources :subscriptions, only: [:create, :destroy]
  end
  
  resources :attachments, only: :destroy

  patch 'mark_best_answer/:id', to: 'answers#mark_best', as: 'answers_mark_best'

  mount ActionCable.server => '/cable'
end
