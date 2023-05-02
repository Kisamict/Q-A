module ControllerVotable
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: :vote_up
  end

  def vote_up
    @votable.vote_up(current_user)

    respond_to do |format|
      format.json { render json: @votable.to_json }
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end

 