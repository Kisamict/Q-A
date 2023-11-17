class QuestionsController < ApplicationController
  include ControllerVotable

  before_action :authenticate_user!, only: %i[new create update destroy vote_up vote_down revote]
  before_action :set_question, only: %i[show edit update destroy vote_up]
  before_action :set_gon_user, only: :show
  before_action :set_gon_question, only: :show
  
  after_action :broadcast_question, only: %i[create]
  
  def index
    respond_with(authorize @questions = Question.all)
  end

  def show
    respond_with(authorize @question)
  end

  def new
    respond_with(authorize @question = Question.new)
  end

  def create
    respond_with(authorize @question = current_user.questions.create(question_params))
  end

  def edit
    authorize @question
  end
  
  def update
    @question.update(question_params) if authorize @question 
    respond_with(@question)
  end

  def destroy
    authorize @question
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(
      :title,
      :body, 
      attachments_attributes: [
        :file,
        :_destroy
      ]
    )
  end

  def set_gon_question
    gon.question_id = @question.id
  end

  def set_gon_user
    gon.current_user = current_user
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def broadcast_question
    ActionCable.server.broadcast('questions', @question.to_json) unless @question.errors.any?
  end
end
