class Api::V1::AnswersController < Api::V1::BaseController 
  before_action :set_question, only: %i[index create]

  def index 
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    authorize Answer
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
