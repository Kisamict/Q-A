class AnswersController < ApplicationController
  include ControllerVotable

  respond_to :js, :html

  before_action :authenticate_user!, only: %i[create destroy vote_up]
  before_action :set_answer, only: %i[update mark_best destroy]
  before_action :set_question, only: %i[create update mark_best]

  after_action :broadcast_answer, only: :create

  def create
    authorize @question
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    authorize @answer
    respond_with(@answer.update(answer_params))
  end

  def destroy 
    authorize @answer
    respond_with(@answer.destroy)
  end

  def mark_best
    authorize @answer
    respond_with(@answer.best!) { |format| format.js { render 'update' } }
  end

  private 

  def set_question
    @question = action_name == 'create' ? Question.find(params[:question_id]) : @answer.question
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
