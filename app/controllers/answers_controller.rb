class AnswersController < ApplicationController
  include ControllerVotable

  before_action :authenticate_user!, only: %i[create destroy vote_up]
  before_action :set_question, only: %i[create update]
  before_action :set_answer, only: %i[edit update mark_best destroy]

  after_action :broadcast_answer, only: :create

  def create 
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy 
    if current_user.author_of?(@answer) 
      respond_with(@answer.destroy)
    else
      redirect_to question_path(@answer.quesiton), flash: { alert: 'You are not the author of this answer!' }
    end
  end

  def mark_best
    respond_with(@answer.best!, location: -> { question_path(@answer.question) }) if current_user.author_of?(@answer.question)
  end

  private 

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def broadcast_answer
    ActionCable.server.broadcast "question_#{@question.id}", @answer.to_json unless @answer.errors.any?
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
