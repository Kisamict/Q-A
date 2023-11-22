class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner                                       
  end

  def index
    all_users_except_current = User.where.not(id: current_resource_owner.id)
    respond_with all_users_except_current
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
