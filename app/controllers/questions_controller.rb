class QuestionsController < ApplicationController
  include ControllerVotable

  before_action :authenticate_user!, only: %i[new create update destroy vote_up]
  before_action :set_question, only: %i[show edit update destroy vote_up]
  before_action :set_gon_user, only: :show
  before_action :set_gon_question, only: :show

  after_action :broadcast_question, only: %i[create]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def edit
  end
  
  def update
    @question.update(question_params) if current_user.author_of?(@question)
    
    respond_with(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with(@question.destroy)
    else
      redirect_to question_path(@question), flash: { alert: 'You are not the author of this question!' }
    end
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
