class Api::V1::AnswersController < ApplicationController
  before_action :doorkeeper_authorize! 

  respond_to :json

  def index 
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end
end
