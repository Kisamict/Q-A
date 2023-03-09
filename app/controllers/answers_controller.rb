class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[create destroy update]
  before_action :set_answer, only: %i[edit update mark_best]

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy 
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer) 
      @answer.destroy!
    else
      flash[:alert] = 'You are not the author of this answer!'
    end
  end

  def mark_best
    @question = @answer.question
    
    @answer.best! if current_user.author_of?(@question)

    render :update
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
      :question_id,
      attachments_attributes: [
        :file,
        :_destroy
      ]
    )
  end
end
