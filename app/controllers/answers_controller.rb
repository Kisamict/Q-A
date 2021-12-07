class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]

  def create 
    @answer = @question.answers.create!(answer_params)

    redirect_to question_answer_path(@question, @answer)
  end

  private 

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(
      :body,
      :question_id
    )
  end
end
