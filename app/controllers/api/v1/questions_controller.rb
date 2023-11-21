class Api::V1::QuestionsController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def index
    respond_with Question.all
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end
end
