class AddQuestionIdToAttachment < ActiveRecord::Migration[6.1]
  def change
    add_reference :attachments, :question, foreign_key: true
  end
end
