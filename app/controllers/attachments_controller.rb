class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment, only: :destroy

  respond_to :js

  def destroy
    authorize @attachment
    respond_with(@attachment.destroy)
  end

  private 

  def set_attachment 
    @attachment = Attachment.find(params[:id])
  end
end
