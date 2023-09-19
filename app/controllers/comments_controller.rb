class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  after_action :stream_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
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
