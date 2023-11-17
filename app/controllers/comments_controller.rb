class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_commentable, only: :create
  after_action :stream_comment, only: :create

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
  end

  def stream_comment
    return if @comment.errors.any?

    id = @commentable.try(:question_id) || @commentable.id
    ActionCable.server.broadcast("question_#{id}_comments", @comment.to_json)
  end
end
