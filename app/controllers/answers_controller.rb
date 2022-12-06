class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[create destroy]

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

   render 'questions/show', locals: { :@answers => @question.answers.reload } unless @answer.save
  end

  def destroy 
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer) 
      @answer.destroy!
    else
      flash[:alert] = 'You are not the author of this answer!'
    end

    redirect_to question_path(@question)
  end

  private 

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(
      :body,
      :question_id
    )
  end
end
