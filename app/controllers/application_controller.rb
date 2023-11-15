require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  self.responder = ApplicationResponder
  respond_to :html

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end
