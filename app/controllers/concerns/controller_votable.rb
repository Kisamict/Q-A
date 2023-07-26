module ControllerVotable
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    respond_to do |format| 
      format.json do 
        render json: @votable if @votable.vote_up(current_user)
      end
    end
  end

  def vote_down
    respond_to do |format| 
      format.json do 
        render json: @votable if @votable.vote_down(current_user)
      end
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
