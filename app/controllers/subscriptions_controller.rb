class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[create destroy]

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with(@subscription, location: question_path(@question))
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    respond_with(@subscription.destroy, location: question_path(@question))
  end
  
  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
