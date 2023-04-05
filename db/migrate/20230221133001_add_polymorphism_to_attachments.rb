class AddPolymorphismToAttachments < ActiveRecord::Migration[6.1]
  def change
    remove_column :attachments, :question_id

    add_reference :attachments, :attachable, polymorphic: true
  end
end
