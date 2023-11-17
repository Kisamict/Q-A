module ControllerVotable
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :revote]
    before_action :authorize_resource, only: %i[vote_up vote_down revote]
  end

  def vote_up
    respond_with(@votable) do |format|
      format.json { render json: @votable if @votable.vote_up(current_user) }
    end
  end

  def vote_down
    respond_with(@votable) do |format|
      format.json { render json: @votable if @votable.vote_down(current_user) }
    end
  end

  def revote
    respond_with(@votable) do |format|
      format.json { render json: @votable if @votable.revote(current_user) }
    end
  end

  private

  def authorize_resource
    authorize @votable, policy_class: VotablePolicy
  end
  
  def set_votable
    votable_klass = controller_name.classify.constantize
    @votable = votable_klass.find(params[:id])
  end
end
