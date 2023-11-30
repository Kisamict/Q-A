class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[create destroy]

  respond_to :js

  def create
    authorize @subscription = @question.subscriptions.new(user: current_user)
    
    head @subscription.save ? 201 : 500
  end

  def destroy
    authorize @subscription = current_user.find_subscription(@question)

    head @subscription.destroy ? 200 : 500
  end
  
  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
