class QuestionsController < ApplicationController
  include ControllerVotable

  before_action :authenticate_user!, only: %i[new create update destroy vote_up]
  before_action :set_question, only: %i[show edit update destroy vote_up]

  after_action :broadcast_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @answer.attachments.build

    gon.question_id = @question.id
    gon.current_user = current_user
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    return redirect_to @question unless current_user.author_of?(@question)

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    else
      flash[:alert] = 'You are not the author of this question!'
    end

    redirect_to questions_path
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

  def set_question
    @question = Question.find(params[:id])
  end

  def broadcast_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', @question.to_json)
  end
end
